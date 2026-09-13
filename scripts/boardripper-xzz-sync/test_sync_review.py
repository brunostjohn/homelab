"""Local regression fixtures for the XZZ sync safety invariants.

These tests replace the HTTP client and use temporary directories only.  They
do not contact Copyparty or mount/write the NAS.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import unittest


MODULE_PATH = Path(__file__).with_name("xzz_sync.py")
SPEC = importlib.util.spec_from_file_location("xzz_sync_review_target", MODULE_PATH)
assert SPEC and SPEC.loader
sync = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(sync)


def digest(data: bytes) -> str:
    return hashlib.md5(data).hexdigest()


class FixtureClient:
    payloads: dict[str, bytes] = {}
    files: dict[str, bytes] = {}
    downloads: list[str] = []

    def __init__(self, base_url: str, credentials_file=None, *, timeout: float = 30.0):
        del base_url, credentials_file, timeout

    def get(self, path: str, *, max_bytes: int) -> bytes:
        del max_bytes
        # Accept both the published remote names and the initial implementation's
        # local snapshot names so this fixture tests sync semantics, not URL spelling.
        aliases = {
            "remote-manifest.txt": "manifest.txt",
            "remote-hashes.json": "hashes.json",
            "remote-SYNCING.md": "SYNCING.md",
        }
        return self.payloads[aliases.get(path, path)]

    def stream_file(self, path: str, output: Path, *, expected_size: int,
                    max_seconds, rate, byte_budget):
        del max_seconds, rate, byte_budget
        data = self.files[path]
        assert len(data) == expected_size
        output.write_bytes(data)
        self.downloads.append(path)
        return digest(data), len(data)


def make_args(root: Path, state: Path, provided_manifest: Path,
              provided_hashes: Path, *, apply: bool = True,
              catalog_drop_fraction: float = 0.05) -> argparse.Namespace:
    argv = [
        "--base-url", "https://example.test/",
        "--root", str(root),
        "--state-dir", str(state),
        "--provided-manifest", str(provided_manifest),
        "--provided-hashes", str(provided_hashes),
        "--max-files", "100",
        "--max-checks", "100",
        "--metadata-limit", "1000000",
        "--catalog-drop-fraction", str(catalog_drop_fraction),
        "--max-seconds", "60",
        "--rate", "0",
    ]
    if apply:
        argv.append("--apply")
    return sync.parser().parse_args(argv)


def seed_baseline(root: Path, state: Path, files: dict[str, bytes]) -> tuple[Path, Path]:
    manifest = root / "provided-manifest.txt"
    hashes = root / "provided-hashes.json"
    manifest.write_text("\n".join(files) + "\n", encoding="utf-8")
    hashes.write_text(json.dumps({
        path: {"md5": digest(data), "size": len(data)}
        for path, data in files.items()
    }), encoding="utf-8")
    del state
    return manifest, hashes


class SyncReviewTests(unittest.TestCase):
    def setUp(self) -> None:
        FixtureClient.payloads = {"SYNCING.md": b"human documentation\n"}
        FixtureClient.files = {}
        FixtureClient.downloads = []
        self.original_client = sync.Client
        sync.Client = FixtureClient

    def tearDown(self) -> None:
        sync.Client = self.original_client

    def prepare(self, baseline: dict[str, bytes], remote: dict[str, bytes]):
        tmp = tempfile.TemporaryDirectory()
        root = Path(tmp.name) / "library"
        root.mkdir()
        state = Path(tmp.name) / "state"
        manifest, hashes = seed_baseline(root, state, baseline)
        FixtureClient.payloads.update({
            "manifest.txt": ("\n".join(remote) + "\n").encode(),
            "hashes.json": json.dumps({
                path: {"md5": digest(data), "size": len(data)}
                for path, data in remote.items()
            }).encode(),
        })
        FixtureClient.files = remote.copy()
        return tmp, root, state, manifest, hashes

    def test_new_download_is_pinned_and_second_run_is_idempotent(self):
        tmp, root, state, manifest, hashes = self.prepare(
            {"baseline.bin": b"baseline"},
            {"baseline.bin": b"baseline", "new.bin": b"new content"},
        )
        with tmp:
            args = make_args(root, state, manifest, hashes)
            first = sync.SyncWorker(args).run()
            self.assertEqual((root / "new.bin").read_bytes(), b"new content")
            pinned = json.loads((state / "xzz-sync-state.json").read_text())[
                "pinned_hashes"
            ]
            self.assertEqual(pinned["new.bin"]["md5"], digest(b"new content"))
            FixtureClient.downloads.clear()
            second = sync.SyncWorker(args).run()
            self.assertFalse(second["errors"], second["errors"])
            self.assertEqual(FixtureClient.downloads, [])
            self.assertTrue(any(a["action"] == "verified" for a in first["actions"]))

    def test_staged_file_corruption_never_replaces_existing_file(self):
        trusted = b"trusted bytes"
        tmp, root, state, manifest, hashes = self.prepare(
            {"repair.bin": trusted}, {"repair.bin": trusted})
        with tmp:
            path = root / "repair.bin"
            path.write_bytes(b"existing bytes")
            worker = sync.SyncWorker(make_args(root, state, manifest, hashes))
            bad_source = root / "staged.bin"
            bad_source.write_bytes(b"corrupt bytes")
            with self.assertRaises(sync.SyncError):
                worker._overwrite_existing(path, bad_source,
                    expected_md5=digest(trusted), journaled=False)
            self.assertEqual(path.read_bytes(), b"existing bytes")

    def test_known_hash_change_is_quarantined_without_download(self):
        tmp, root, state, manifest, hashes = self.prepare(
            {"known.bin": b"trusted"},
            {"known.bin": b"poisoned"},
        )
        path = root / "known.bin"
        path.write_bytes(b"trusted")
        with tmp:
            report = sync.SyncWorker(make_args(root, state, manifest, hashes)).run()
            self.assertEqual(path.read_bytes(), b"trusted")
            self.assertEqual(FixtureClient.downloads, [])
            self.assertTrue(any(e["kind"] == "changed_remote_hash" for e in report["errors"]))

    def test_repair_preserves_identity_and_mode_metadata(self):
        trusted = b"trusted bytes"
        tmp, root, state, manifest, hashes = self.prepare(
            {"repair.bin": trusted},
            {"repair.bin": trusted},
        )
        path = root / "repair.bin"
        path.write_bytes(b"local corruption")
        os.chmod(path, 0o640)
        before = path.stat()
        with tmp:
            report = sync.SyncWorker(make_args(root, state, manifest, hashes)).run()
            after = path.stat()
            self.assertEqual(path.read_bytes(), trusted)
            self.assertTrue(any(a["action"] == "repair" for a in report["actions"]))
            self.assertEqual(after.st_ino, before.st_ino)
            self.assertEqual(after.st_dev, before.st_dev)
            self.assertEqual(after.st_mode & 0o7777, before.st_mode & 0o7777)
            self.assertEqual(after.st_uid, before.st_uid)
            self.assertEqual(after.st_gid, before.st_gid)

    def test_catalog_drop_freezes_before_touching_local_files(self):
        baseline = {"one.bin": b"one", "two.bin": b"two"}
        tmp, root, state, manifest, hashes = self.prepare(
            baseline, {"one.bin": b"one"}
        )
        for name, data in baseline.items():
            (root / name).write_bytes(data)
        before = {name: (root / name).stat().st_mtime_ns for name in baseline}
        with tmp:
            with self.assertRaises(sync.FrozenError):
                sync.SyncWorker(make_args(root, state, manifest, hashes)).run()
            self.assertEqual(
                before,
                {name: (root / name).stat().st_mtime_ns for name in baseline},
            )

    def test_hash_entries_outside_manifest_are_reported_without_failure(self):
        tmp, root, state, manifest, hashes = self.prepare(
            {"one.bin": b"one"}, {"one.bin": b"one"}
        )
        remote_hashes = json.loads(FixtureClient.payloads["hashes.json"])
        remote_hashes["current-but-unlisted.bin"] = {
            "md5": digest(b"current but unlisted"),
            "size": len(b"current but unlisted"),
        }
        FixtureClient.payloads["hashes.json"] = json.dumps(remote_hashes).encode()
        with tmp:
            report = sync.SyncWorker(make_args(root, state, manifest, hashes)).run()
            self.assertFalse(report["errors"], report["errors"])
            self.assertFalse((root / "current-but-unlisted.bin").exists())

    def test_pending_repair_journal_points_to_retained_backup(self):
        with tempfile.TemporaryDirectory() as dirname:
            root = Path(dirname) / "library"
            root.mkdir()
            state = Path(dirname) / "state"
            state.mkdir()
            destination = root / "repair.bin"
            source = root / ".repair.incoming"
            destination.write_bytes(b"old")
            source.write_bytes(b"new")
            worker = object.__new__(sync.SyncWorker)
            worker.root = root
            worker.state_dir = state
            worker.journal_path = state / "pending-repair.json"
            backup = worker._backup_existing(destination, "repair.bin")

            original_atomic_json = sync.atomic_json
            original_fsync = sync.os.fsync

            def test_atomic_json(path: Path, value):
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(json.dumps(value), encoding="utf-8")

            def simulated_crash(fd):
                del fd
                raise OSError("simulated crash")

            sync.atomic_json = test_atomic_json
            sync.os.fsync = simulated_crash
            try:
                with self.assertRaises(sync.SyncError):
                    worker._overwrite_existing(
                        destination, source, expected_md5=digest(b"new"),
                        backup_path=backup,
                    )
            finally:
                sync.atomic_json = original_atomic_json
                sync.os.fsync = original_fsync

            journal = json.loads(worker.journal_path.read_text(encoding="utf-8"))
            self.assertEqual(Path(journal["backup"]).resolve(), backup.resolve())


if __name__ == "__main__":
    unittest.main()
