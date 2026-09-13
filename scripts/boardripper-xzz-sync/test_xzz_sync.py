import hashlib
import json
import os
from pathlib import Path
import tempfile
import unittest

from xzz_sync import (
    Client,
    FrozenError,
    SameOriginRedirectHandler,
    SyncError,
    SyncWorker,
    parser,
    safe_destination,
    validate_remote_path,
)


class FixtureClient:
    def __init__(self, manifest, hashes, files):
        self.manifest = manifest
        self.hashes = hashes
        self.files = files
        self.requests = []

    def get(self, path, **_kwargs):
        self.requests.append(path)
        if path == "manifest.txt":
            return ("\n".join(self.manifest) + "\n").encode()
        if path == "hashes.json":
            return json.dumps(self.hashes).encode()
        raise SyncError("unexpected metadata request")

    def stream_file(self, path, output, *, expected_size, **_kwargs):
        self.requests.append(path)
        body = self.files[path]
        with output.open("xb") as fh:
            fh.write(body)
            fh.flush()
            os.fsync(fh.fileno())
        return hashlib.md5(body).hexdigest(), len(body)


class ResponseStub:
    def __init__(self, body, length=None):
        self.body = body
        self.position = 0
        self.headers = {} if length is None else {"Content-Length": str(length)}

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        return False

    def read(self, amount=-1):
        if amount < 0:
            amount = len(self.body)
        result = self.body[self.position:self.position + amount]
        self.position += len(result)
        return result


def record(data):
    return {"md5": hashlib.md5(data).hexdigest(), "size": len(data)}


def args_for(root, state, _server, manifest, hashes, **extra):
    with tempfile.NamedTemporaryFile("w", delete=False) as mf:
        mf.write("\n".join(manifest) + "\n")
        manifest_file = mf.name
    with tempfile.NamedTemporaryFile("w", delete=False) as hf:
        json.dump(hashes, hf)
        hashes_file = hf.name
    values = [
        "--base-url", "https://example.test",
        "--root", str(root), "--state-dir", str(state),
        "--provided-manifest", manifest_file, "--provided-hashes", hashes_file,
        "--max-files", "100", "--max-checks", "100", "--rate", "0",
        "--dry-report",
    ]
    if extra.get("apply"):
        values.append("--apply")
    if extra.get("only_path"):
        values += ["--only-path", extra["only_path"]]
    if extra.get("verified_aliases"):
        values += ["--verified-aliases", extra["verified_aliases"]]
    if extra.get("boardripper_url"):
        values += ["--boardripper-url", extra["boardripper_url"]]
    return parser().parse_args(values)


class XzzSyncTests(unittest.TestCase):
    def test_path_validation_and_symlink_component(self):
        for value in ("/x", "../x", "a/../x", "a\\x", "a//x", "a/./x", "C:x"):
            with self.assertRaises(SyncError):
                validate_remote_path(value)
        with tempfile.TemporaryDirectory() as td:
            root = Path(td) / "root"
            root.mkdir()
            outside = Path(td) / "outside"
            outside.mkdir()
            (root / "escape").symlink_to(outside, target_is_directory=True)
            with self.assertRaises(SyncError):
                safe_destination(root, "escape/file")

    def test_client_same_origin_redirect(self):
        handler = SameOriginRedirectHandler("https://example.test/")
        with self.assertRaises(SyncError):
            handler.redirect_request(
                type("Req", (), {"full_url": "https://example.test/a"})(),
                None, 302, "", {"Location": "https://evil.test/x"}, "https://evil.test/x"
            )

    def test_content_length_mismatch_is_rejected_before_acceptance(self):
        client = Client("https://example.test")
        client.opener = type("Opener", (), {"open": lambda *_args, **_kwargs: ResponseStub(b"abc", 4)})()
        with tempfile.TemporaryDirectory() as td:
            output = Path(td) / ".part"
            with self.assertRaises(SyncError):
                client.stream_file("file.bin", output, expected_size=3, max_seconds=2, rate=0, byte_budget=None)
            self.assertFalse(output.exists())

    def test_missing_download_is_content_length_and_hash_verified(self):
        path = "Repair Schematics/XZZ2025/new.bin"
        data = b"verified bytes\n"
        hashes = {path: record(data)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            fake = FixtureClient([path], hashes, {path: data})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                report = SyncWorker(args_for(root, state, fake, [path], hashes, apply=True)).run()
            finally:
                __import__("xzz_sync").Client = original
            destination = root / path
            self.assertEqual(destination.read_bytes(), data)
            self.assertEqual([a["action"] for a in report["actions"] if "action" in a][-1], "download")

    def test_repair_keeps_inode_and_mode_and_keeps_backup(self):
        path = "Repair Schematics/XZZ2025/repair.bin"
        good, bad = b"new-good", b"old-bad"
        hashes = {path: record(good)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            destination = root / path
            destination.parent.mkdir(parents=True)
            destination.write_bytes(bad)
            os.chmod(destination, 0o640)
            before = destination.stat()
            fake = FixtureClient([path], hashes, {path: good})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                report = SyncWorker(args_for(root, state, fake, [path], hashes, apply=True)).run()
            finally:
                __import__("xzz_sync").Client = original
            after = destination.stat()
            self.assertEqual(destination.read_bytes(), good)
            self.assertEqual((before.st_ino, before.st_dev, before.st_mode), (after.st_ino, after.st_dev, after.st_mode))
            backups = list((root / ".xzz-sync-backups").glob("*.bak"))
            self.assertEqual(len(backups), 1)
            self.assertEqual(backups[0].read_bytes(), bad)
            self.assertTrue(any(a["action"] == "repair" for a in report["actions"]))

    def test_changed_remote_hash_is_review_only(self):
        path = "Repair Schematics/XZZ2025/pinned.bin"
        old, new = b"old", b"new"
        hashes_old = {path: record(old)}
        hashes_new = {path: record(new)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            destination = root / path
            destination.parent.mkdir(parents=True)
            destination.write_bytes(b"corrupt")
            fake = FixtureClient([path], hashes_new, {path: new})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                # Seed the trusted baseline with the old pinned version.
                SyncWorker(args_for(root, state, fake, [path], hashes_old)).bootstrap_or_load()
                report = SyncWorker(args_for(root, state, fake, [path], hashes_new, apply=True)).run()
            finally:
                __import__("xzz_sync").Client = original
            self.assertEqual(destination.read_bytes(), b"corrupt")
            self.assertTrue(any(e["kind"] == "changed_remote_hash" for e in report["errors"]))
            self.assertNotIn(path, fake.requests)

    def test_unhashed_existing_file_is_deferred(self):
        path = "Repair Schematics/XZZ2025/nohash.bin"
        data = b"local"
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            destination = root / path
            destination.parent.mkdir(parents=True)
            destination.write_bytes(data)
            hashes = {}
            fake = FixtureClient([path], hashes, {})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                # hashes absent from manifest are valid for the known 680-gap case.
                # The worker reports this path and leaves it untouched.
                report = SyncWorker(args_for(root, state, fake, [path], hashes)).run()
            finally:
                __import__("xzz_sync").Client = original
            self.assertEqual(destination.read_bytes(), data)
            self.assertTrue(any(e["kind"] == "missing_remote_hash" for e in report["warnings"]))

    def test_verified_alias_avoids_duplicate_download(self):
        remote = "Repair Schematics/XZZ2025/mirror.pdf"
        local = "Repair Schematics/XZZ2025/existing.pdf"
        data = b"already verified"
        hashes = {remote: record(data)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            existing = root / local
            existing.parent.mkdir(parents=True)
            existing.write_bytes(data)
            st = existing.stat()
            alias_path = Path(td) / "aliases.json"
            alias_path.write_text(json.dumps({"matches": [{
                "remote_path": remote, "local_path": local, "md5": hashes[remote]["md5"],
                "size": len(data), "mtime_ns": st.st_mtime_ns, "inode": st.st_ino,
            }]}))
            fake = FixtureClient([remote], hashes, {remote: data})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                report = SyncWorker(args_for(root, state, fake, [remote], hashes, verified_aliases=str(alias_path))).run()
            finally:
                __import__("xzz_sync").Client = original
            self.assertFalse((root / remote).exists())
            self.assertTrue(any(a["action"] == "alias_used" for a in report["actions"]))
            self.assertNotIn(remote, fake.requests)

    def test_accepted_pin_ledger_cannot_replace_baseline_or_be_symlink(self):
        path = "Repair Schematics/XZZ2025/pinned.bin"
        good, conflicting = b"trusted", b"conflicting"
        hashes = {path: record(good)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            fake = FixtureClient([path], hashes, {path: good})
            module = __import__("xzz_sync")
            original = module.Client
            module.Client = lambda *_args, **_kwargs: fake
            try:
                worker = SyncWorker(args_for(root, state, fake, [path], hashes))
                worker.bootstrap_or_load()
                ledger = state / "accepted-pins.jsonl"
                ledger.write_text(json.dumps({"path": path, **record(conflicting)}) + "\n")
                loaded = SyncWorker(args_for(root, state, fake, [path], hashes)).bootstrap_or_load()
                self.assertEqual(loaded["pinned_hashes"][path], hashes[path])
                ledger.unlink()
                ledger.symlink_to(Path(td) / "outside-ledger")
                with self.assertRaises(SyncError):
                    SyncWorker(args_for(root, state, fake, [path], hashes)).bootstrap_or_load()
            finally:
                module.Client = original

    def test_free_space_reserve_blocks_transfer(self):
        path = "Repair Schematics/XZZ2025/space.bin"
        data = b"space"
        hashes = {path: record(data)}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            fake = FixtureClient([path], hashes, {path: data})
            module = __import__("xzz_sync")
            original_client, original_usage = module.Client, module.shutil.disk_usage
            module.Client = lambda *_args, **_kwargs: fake
            module.shutil.disk_usage = lambda _path: type("Usage", (), {"free": 0})()
            try:
                report = SyncWorker(args_for(root, state, fake, [path], hashes, apply=True)).run()
            finally:
                module.Client, module.shutil.disk_usage = original_client, original_usage
            self.assertFalse((root / path).exists())
            self.assertTrue(any(e["kind"] == "path_error" for e in report["errors"]))

    def test_refresh_hook_pending_then_retried_and_no_xzz_auth(self):
        path = "Repair Schematics/XZZ2025/hook.bin"
        data = b"hook me"
        hashes = {path: record(data)}

        class Hook:
            results = iter(("running", "complete"))
            calls = 0

            def __init__(self, url, *, timeout):
                self.url, self.timeout = url, timeout

            def trigger(self):
                type(self).calls += 1
                return next(type(self).results)

        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            fake = FixtureClient([path], hashes, {path: data})
            module = __import__("xzz_sync")
            original_client, original_hook = module.Client, module.BoardRipperRefresh
            module.Client = lambda *_args, **_kwargs: fake
            module.BoardRipperRefresh = Hook
            try:
                first = SyncWorker(args_for(root, state, fake, [path], hashes, apply=True,
                                            boardripper_url="http://boardripper/refresh")).run()
                self.assertEqual(json.loads((state / "xzz-sync-state.json").read_text())["refresh_pending"]["reason"], "scan_running")
                second = SyncWorker(args_for(root, state, fake, [path], hashes, apply=True,
                                             boardripper_url="http://boardripper/refresh")).run()
            finally:
                module.Client, module.BoardRipperRefresh = original_client, original_hook
            self.assertEqual(Hook.calls, 2)
            self.assertNotIn("refresh_pending", json.loads((state / "xzz-sync-state.json").read_text()))
            self.assertTrue(any(a["action"] == "boardripper_refresh" for a in first["actions"]))
            self.assertTrue(any(a["status"] == "complete" for a in second["actions"] if a["action"] == "boardripper_refresh"))

    def test_boardripper_request_has_no_xzz_authorization_header(self):
        import urllib.request

        class Response:
            status = 204

            def __enter__(self):
                return self

            def __exit__(self, *_args):
                return False

        class Opener:
            def open(self, request, timeout):
                self.request = request
                return Response()

        hook = __import__("xzz_sync").BoardRipperRefresh("http://boardripper/refresh")
        opener = Opener()
        hook.opener = opener
        self.assertEqual(hook.trigger(), "complete")
        self.assertNotIn("Authorization", opener.request.headers)

    def test_catalog_drop_freezes(self):
        old_path = "Repair Schematics/XZZ2025/a.bin"
        new_path = "Repair Schematics/XZZ2025/b.bin"
        hashes = {old_path: record(b"a")}
        with tempfile.TemporaryDirectory() as td:
            root, state = Path(td) / "library", Path(td) / "state"
            root.mkdir()
            fake = FixtureClient([old_path, new_path], hashes, {old_path: b"a"})
            original = __import__("xzz_sync").Client
            __import__("xzz_sync").Client = lambda *_args, **_kwargs: fake
            try:
                SyncWorker(args_for(root, state, fake, [old_path, new_path], hashes)).bootstrap_or_load()
                fake.manifest = [old_path]
                worker = SyncWorker(args_for(root, state, fake, [old_path], hashes))
                # Baseline is two paths, current one is below a 5% drop threshold.
                with self.assertRaises(FrozenError):
                    worker.run()
            finally:
                __import__("xzz_sync").Client = original


if __name__ == "__main__":
    unittest.main()
