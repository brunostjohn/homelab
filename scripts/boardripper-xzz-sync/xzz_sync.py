#!/usr/bin/env python3
"""Bounded, hash-pinned incremental mirror for the XZZ Copyparty library.

The worker deliberately has no archive extraction, command execution, metadata
repair, or deletion code.  It is dry-run by default; ``--apply`` is required
for downloads and in-place repairs.
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import stat
import sys
import tempfile
import time
from typing import Any, Mapping
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urljoin, urlsplit
from urllib.request import (
    HTTPBasicAuthHandler,
    HTTPPasswordMgrWithDefaultRealm,
    HTTPRedirectHandler,
    Request,
    build_opener,
)


DEFAULT_BASE_URL = "https://xzzcopyparty.slimeinacloak.com"
DEFAULT_ROOT = "/library/XZZ 2025"
DEFAULT_STATE_DIR = "/state"
USER_AGENT = "XZZ-Library-Sync/1.0"
DEFAULT_FREE_RESERVE = 5 * 1024 * 1024 * 1024
MD5_RE = re.compile(r"^[0-9a-fA-F]{32}$")


class SyncError(RuntimeError):
    pass


class FrozenError(SyncError):
    pass


def atomic_json(path: Path, value: Any) -> None:
    """Write JSON with a replace, and fsync both the file and directory."""
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, name = tempfile.mkstemp(prefix=f".{path.name}.", suffix=".tmp", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            json.dump(value, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
            fh.write("\n")
            fh.flush()
            os.fsync(fh.fileno())
        os.replace(name, path)
        try:
            dfd = os.open(path.parent, os.O_RDONLY)
            try:
                os.fsync(dfd)
            finally:
                os.close(dfd)
        except OSError:
            pass
    finally:
        try:
            os.unlink(name)
        except FileNotFoundError:
            pass


def read_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def validate_remote_path(value: str) -> str:
    """Validate a URL/path relative to the mirror root.

    Empty components are rejected to avoid aliases such as ``a//b``.  Unicode
    names are retained, while separators remain POSIX-only and dot components
    are never accepted.
    """
    if not isinstance(value, str) or not value or "\x00" in value:
        raise SyncError("invalid remote path")
    if "\\" in value or value.startswith("/") or value.startswith("~"):
        raise SyncError(f"unsafe remote path: {value!r}")
    parts = value.split("/")
    if any(part in ("", ".", "..") for part in parts):
        raise SyncError(f"unsafe remote path: {value!r}")
    if any(part == ".xzz-sync-backups" or part.startswith(".xzz-sync-") for part in parts):
        raise SyncError("reserved sync control path")
    # A drive prefix is absolute on Windows and surprising on NAS mounts.
    if len(parts[0]) >= 2 and parts[0][1] == ":":
        raise SyncError(f"unsafe remote path: {value!r}")
    return "/".join(parts)


def safe_destination(root: Path, remote_path: str, *, create_parents: bool = False) -> Path:
    remote_path = validate_remote_path(remote_path)
    root = root.absolute()
    # The root itself must not be a symlink.  Existing data is never followed
    # through a symlink, including intermediate directories.
    try:
        rst = os.lstat(root)
    except FileNotFoundError:
        raise SyncError(f"destination root does not exist: {root}")
    if stat.S_ISLNK(rst.st_mode) or not stat.S_ISDIR(rst.st_mode):
        raise SyncError("destination root is not a real directory")
    current = root
    parts = remote_path.split("/")
    for part in parts[:-1]:
        current = current / part
        try:
            st = os.lstat(current)
        except FileNotFoundError:
            if not create_parents:
                continue
            current.mkdir()
            st = os.lstat(current)
        if stat.S_ISLNK(st.st_mode) or not stat.S_ISDIR(st.st_mode):
            raise SyncError(f"destination component is not a directory: {current}")
    destination = current / parts[-1]
    try:
        dst = os.lstat(destination)
        if stat.S_ISLNK(dst.st_mode):
            raise SyncError(f"destination is a symlink: {destination}")
    except FileNotFoundError:
        pass
    return destination


def parse_manifest_bytes(raw: bytes) -> list[str]:
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise SyncError("manifest is not UTF-8") from exc
    paths: list[str] = []
    seen: set[str] = set()
    for lineno, line in enumerate(text.splitlines(), 1):
        if not line:
            continue
        try:
            path = validate_remote_path(line)
        except SyncError as exc:
            raise SyncError(f"invalid manifest line {lineno}") from exc
        if path in seen:
            raise SyncError(f"duplicate manifest path at line {lineno}")
        seen.add(path)
        paths.append(path)
    if not paths:
        raise SyncError("empty manifest")
    return paths


def parse_hashes_bytes(raw: bytes) -> dict[str, dict[str, int | str]]:
    try:
        document = json.loads(raw.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise SyncError("invalid hashes JSON") from exc
    if not isinstance(document, dict):
        raise SyncError("hashes JSON must be an object")
    result: dict[str, dict[str, int | str]] = {}
    for key, value in document.items():
        path = validate_remote_path(key)
        if not isinstance(value, dict) or not MD5_RE.fullmatch(str(value.get("md5", ""))):
            raise SyncError(f"invalid hash entry for {path!r}")
        size = value.get("size")
        if isinstance(size, bool) or not isinstance(size, int) or size < 0:
            raise SyncError(f"invalid size entry for {path!r}")
        result[path] = {"md5": str(value["md5"]).lower(), "size": size}
    return result


def md5_file(path: Path, *, max_seconds: float | None = None) -> tuple[str, int]:
    digest = hashlib.md5()
    size = 0
    started = time.monotonic()
    with path.open("rb") as fh:
        while True:
            block = fh.read(1024 * 1024)
            if not block:
                break
            digest.update(block)
            size += len(block)
            if max_seconds is not None and time.monotonic() - started > max_seconds:
                raise SyncError("hashing time bound exceeded")
    return digest.hexdigest(), size


def same_origin(expected: str, candidate: str) -> bool:
    a, b = urlsplit(expected), urlsplit(candidate)
    return (
        a.scheme.lower() == b.scheme.lower()
        and a.hostname and b.hostname and a.hostname.lower() == b.hostname.lower()
        and (a.port or (443 if a.scheme.lower() == "https" else 80))
        == (b.port or (443 if b.scheme.lower() == "https" else 80))
    )


class SameOriginRedirectHandler(HTTPRedirectHandler):
    def __init__(self, origin: str):
        super().__init__()
        self.origin = origin

    def redirect_request(self, req, fp, code, msg, headers, newurl):  # type: ignore[no-untyped-def]
        if not same_origin(self.origin, newurl):
            raise SyncError("refusing cross-origin redirect")
        return super().redirect_request(req, fp, code, msg, headers, newurl)


class Client:
    def __init__(self, base_url: str, credentials_file: Path | None = None, *, timeout: float = 30.0):
        parsed = urlsplit(base_url)
        if parsed.scheme not in {"https", "http"} or not parsed.hostname or parsed.query or parsed.fragment:
            raise SyncError("invalid base URL")
        self.base = base_url.rstrip("/") + "/"
        self.origin = f"{parsed.scheme}://{parsed.netloc}/"
        manager = HTTPPasswordMgrWithDefaultRealm()
        env_user = os.environ.get("USERNAME")
        env_password = os.environ.get("PASSWORD")
        if isinstance(env_user, str) and isinstance(env_password, str) and env_user and env_password:
            user, password = env_user, env_password
        elif credentials_file is not None:
            try:
                creds = read_json(credentials_file)
                user = creds.get("username", creds.get("user"))
                password = creds.get("password", creds.get("pass"))
            except (OSError, ValueError, AttributeError) as exc:
                raise SyncError("could not read credentials file") from exc
            if not isinstance(user, str) or not isinstance(password, str):
                raise SyncError("credentials file must contain username/password")
        else:
            user = password = None
        self.auth_header = None
        if user is not None and password is not None:
            manager.add_password(None, self.origin, user, password)
            encoded = base64.b64encode(f"{user}:{password}".encode("utf-8")).decode("ascii")
            self.auth_header = f"Basic {encoded}"
        self.opener = build_opener(
            HTTPBasicAuthHandler(manager), SameOriginRedirectHandler(self.origin)
        )
        self.timeout = timeout

    def _url(self, path: str) -> str:
        path = validate_remote_path(path)
        return urljoin(self.base, quote(path, safe="/"))

    def get(self, path: str, *, max_bytes: int) -> bytes:
        url = self._url(path)
        headers = {"User-Agent": USER_AGENT, "Accept-Encoding": "identity"}
        if self.auth_header:
            headers["Authorization"] = self.auth_header
        req = Request(url, headers=headers)
        try:
            with self.opener.open(req, timeout=self.timeout) as response:
                length = response.headers.get("Content-Length")
                if length is not None:
                    try:
                        if int(length) > max_bytes:
                            raise SyncError("metadata exceeds configured limit")
                    except ValueError as exc:
                        raise SyncError("invalid Content-Length") from exc
                data = response.read(max_bytes + 1)
                if len(data) > max_bytes:
                    raise SyncError("metadata exceeds configured limit")
                return data
        except (HTTPError, URLError, TimeoutError, OSError) as exc:
            raise SyncError(f"metadata request failed for {path}") from exc

    def stream_file(self, path: str, output: Path, *, expected_size: int, max_seconds: float | None,
                    rate: float | None, byte_budget: int | None) -> tuple[str, int]:
        url = self._url(path)
        headers = {"User-Agent": USER_AGENT, "Accept-Encoding": "identity"}
        if self.auth_header:
            headers["Authorization"] = self.auth_header
        req = Request(url, headers=headers)
        digest = hashlib.md5()
        total = 0
        self.last_bytes = 0
        started = time.monotonic()
        try:
            with self.opener.open(req, timeout=self.timeout) as response:
                header_length = response.headers.get("Content-Length")
                if header_length is not None:
                    try:
                        if int(header_length) != expected_size:
                            raise SyncError("remote Content-Length disagrees with pinned size")
                    except ValueError as exc:
                        raise SyncError("invalid remote Content-Length") from exc
                with output.open("xb") as fh:
                    while True:
                        block = response.read(1024 * 1024)
                        if not block:
                            break
                        total += len(block)
                        self.last_bytes = total
                        if total > expected_size or (byte_budget is not None and total > byte_budget):
                            raise SyncError("download byte bound exceeded")
                        fh.write(block)
                        digest.update(block)
                        if rate and rate > 0:
                            elapsed = time.monotonic() - started
                            target = total / rate
                            if target > elapsed:
                                time.sleep(min(target - elapsed, 1.0))
                        if max_seconds is not None and time.monotonic() - started > max_seconds:
                            raise SyncError("download time bound exceeded")
                    fh.flush()
                    os.fsync(fh.fileno())
        except (HTTPError, URLError, TimeoutError, OSError) as exc:
            raise SyncError(f"download failed for {path}") from exc
        if total != expected_size:
            raise SyncError("download size disagrees with pinned size")
        return digest.hexdigest(), total


class BoardRipperRefresh:
    """Small unauthenticated-to-XZZ, separately addressed refresh hook."""

    def __init__(self, url: str, *, timeout: float = 30.0):
        parsed = urlsplit(url)
        if parsed.scheme not in {"http", "https"} or not parsed.hostname:
            raise SyncError("invalid BoardRipper refresh URL")
        self.url = url
        self.timeout = timeout
        self.opener = build_opener(SameOriginRedirectHandler(f"{parsed.scheme}://{parsed.netloc}/"))

    def trigger(self) -> str:
        # This opener has no BasicAuthHandler and the request carries no XZZ
        # credentials or Authorization header. BOARDRIPPER_URL is the exact
        # service hook supplied by the deployment.
        request = Request(
            self.url, data=b"{}", method="POST",
            headers={"User-Agent": USER_AGENT, "Content-Type": "application/json"},
        )
        try:
            with self.opener.open(request, timeout=self.timeout) as response:
                status_value = getattr(response, "status", None)
                if status_value is None:
                    status_value = response.getcode()
                status = int(status_value)
                if status == 202 or status == 409:
                    return "running"
                if 200 <= status < 300:
                    return "complete"
                return "failed"
        except HTTPError as exc:
            if exc.code == 409:
                return "running"
            return "failed"
        except (URLError, TimeoutError, OSError):
            return "failed"


def stat_fingerprint(path: Path) -> dict[str, int]:
    st = os.lstat(path)
    if stat.S_ISLNK(st.st_mode) or not stat.S_ISREG(st.st_mode):
        raise SyncError(f"local path is not a regular file: {path}")
    return {
        "size": st.st_size, "mtime_ns": st.st_mtime_ns, "inode": st.st_ino,
        "dev": st.st_dev, "mode": stat.S_IMODE(st.st_mode), "uid": st.st_uid, "gid": st.st_gid,
    }


def load_credentials_path(cli: str | None) -> Path | None:
    value = cli or os.environ.get("XZZ_CREDENTIALS_FILE")
    return Path(value) if value else None


class SyncWorker:
    def __init__(self, args: argparse.Namespace):
        self.args = args
        self.root = Path(args.root).absolute()
        self.state_dir = Path(args.state_dir).absolute()
        self.state_path = self.state_dir / "xzz-sync-state.json"
        self.journal_path = self.state_dir / "pending-repair.json"
        self.accepted_pins_path = self.state_dir / "accepted-pins.jsonl"
        self.report: dict[str, Any] = {
            "started_at": time.time(), "dry_run": not args.apply,
            "actions": [], "errors": [], "warnings": [],
        }
        self.started = time.monotonic()
        self.bytes_used = 0
        self.files_used = 0
        self.checks_used = 0
        self.progress_since_checkpoint = 0

    def check_time(self) -> None:
        if self.args.max_seconds is not None and time.monotonic() - self.started >= self.args.max_seconds:
            raise SyncError("run time bound exceeded")

    def remaining_seconds(self) -> float | None:
        if self.args.max_seconds is None:
            return None
        return max(0.0, self.args.max_seconds - (time.monotonic() - self.started))

    def _append_accepted_pin(self, path: str, expected: Mapping[str, Any]) -> None:
        self.state_dir.mkdir(parents=True, exist_ok=True)
        try:
            if stat.S_ISLNK(os.lstat(self.accepted_pins_path).st_mode):
                raise SyncError("accepted pin ledger is a symlink")
        except FileNotFoundError:
            pass
        record = {"path": path, "md5": str(expected["md5"]).lower(), "size": int(expected["size"]), "accepted_at": time.time()}
        with self.accepted_pins_path.open("a", encoding="utf-8") as fh:
            fh.write(json.dumps(record, sort_keys=True, separators=(",", ":")) + "\n")
            fh.flush()
            os.fsync(fh.fileno())

    def _load_accepted_pins(self, state: dict[str, Any]) -> None:
        try:
            ledger_stat = os.lstat(self.accepted_pins_path)
        except FileNotFoundError:
            return
        if stat.S_ISLNK(ledger_stat.st_mode) or not stat.S_ISREG(ledger_stat.st_mode):
            raise SyncError("accepted pin ledger is not a regular file")
        pinned = state.setdefault("pinned_hashes", {})
        try:
            with self.accepted_pins_path.open("r", encoding="utf-8") as fh:
                for line in fh:
                    try:
                        item = json.loads(line)
                        path = validate_remote_path(item["path"])
                        md5 = str(item["md5"]).lower()
                        size = int(item["size"])
                        if MD5_RE.fullmatch(md5) and size >= 0:
                            pin = {"md5": md5, "size": size}
                            if path in pinned and pinned[path] != pin:
                                self.report["errors"].append({"kind": "accepted_pin_conflict", "path": path})
                            else:
                                pinned[path] = pin
                    except (ValueError, KeyError, TypeError, SyncError):
                        continue
        except OSError as exc:
            raise SyncError("could not read accepted pin ledger") from exc

    def bootstrap_or_load(self) -> dict[str, Any]:
        if self.state_path.exists():
            state = read_json(self.state_path)
            if not isinstance(state, dict) or not isinstance(state.get("pinned_hashes"), dict):
                raise SyncError("invalid sync state")
            self._load_accepted_pins(state)
            return state
        if not self.args.provided_manifest or not self.args.provided_hashes:
            raise SyncError("first run requires trusted --provided-manifest and --provided-hashes")
        manifest = parse_manifest_bytes(Path(self.args.provided_manifest).read_bytes())
        hashes = parse_hashes_bytes(Path(self.args.provided_hashes).read_bytes())
        extras = sorted(set(hashes) - set(manifest))
        manifest_set = set(manifest)
        hashes = {path: value for path, value in hashes.items() if path in manifest_set}
        state = {
            "schema": 1,
            "created_at": time.time(),
            "baseline_manifest": manifest,
            "baseline_count": len(manifest),
            "pinned_hashes": hashes,
            "verified_cache": {},
            "aliases": {},
            "run_count": 0,
        }
        if self.args.verified_aliases:
            state["aliases"] = self._load_aliases(Path(self.args.verified_aliases), state)
        if extras:
            self.report["warnings"].append({"kind": "trusted_hashes_outside_manifest", "count": len(extras)})
        # State is control-plane data and may be initialized during a dry run;
        # the NAS root remains untouched until --apply.
        atomic_json(self.state_path, state)
        self._load_accepted_pins(state)
        self.report["actions"].append({"action": "bootstrap_state", "count": len(manifest)})
        return state

    def _load_aliases(self, path: Path, state: Mapping[str, Any]) -> dict[str, Any]:
        try:
            document = read_json(path)
            matches = document.get("matches", [])
        except (OSError, ValueError, AttributeError) as exc:
            raise SyncError("could not read verified aliases") from exc
        if not isinstance(matches, list):
            raise SyncError("verified aliases matches must be a list")
        aliases: dict[str, Any] = {}
        pinned = state.get("pinned_hashes", {})
        for item in matches:
            if not isinstance(item, dict):
                continue
            try:
                remote = validate_remote_path(item["remote_path"])
                local = validate_remote_path(item["local_path"])
                md5 = str(item["md5"]).lower()
                size = int(item["size"])
                mtime_ns = int(item["mtime_ns"])
                inode = int(item["inode"])
            except (KeyError, TypeError, ValueError, SyncError):
                continue
            pin = pinned.get(remote)
            if not isinstance(pin, dict) or md5 != pin.get("md5") or size != pin.get("size"):
                continue
            aliases[remote] = {"local_path": local, "md5": md5, "size": size, "mtime_ns": mtime_ns, "inode": inode}
        return aliases

    def _checkpoint(self, state: dict[str, Any], cache: Mapping[str, Any], manifest_count: int) -> None:
        state["verified_cache"] = dict(cache)
        state["last_manifest_count"] = manifest_count
        state["updated_at"] = time.time()
        atomic_json(self.state_path, state)
        self.progress_since_checkpoint = 0

    def _ensure_free_space(self, required: int) -> None:
        try:
            free = shutil.disk_usage(self.root).free
        except OSError as exc:
            raise SyncError("could not inspect destination free space") from exc
        if free < self.args.free_reserve_bytes + max(0, required):
            raise SyncError("destination free-space reserve would be breached")

    def _maybe_checkpoint(self, state: dict[str, Any], cache: Mapping[str, Any], manifest_count: int) -> None:
        self.progress_since_checkpoint += 1
        if self.progress_since_checkpoint >= self.args.checkpoint_every:
            self._checkpoint(state, cache, manifest_count)

    def recover_journal(self) -> None:
        if not self.journal_path.exists():
            return
        journal = read_json(self.journal_path)
        path = journal.get("path") if isinstance(journal, dict) else None
        backup = journal.get("backup") if isinstance(journal, dict) else None
        if not isinstance(path, str) or not isinstance(backup, str):
            raise SyncError("invalid pending repair journal; manual review required")
        destination = safe_destination(self.root, path)
        backup_root = self.root / ".xzz-sync-backups"
        try:
            backup_root_stat = os.lstat(backup_root)
        except FileNotFoundError as exc:
            raise SyncError("pending repair backup directory is missing") from exc
        if stat.S_ISLNK(backup_root_stat.st_mode) or not stat.S_ISDIR(backup_root_stat.st_mode):
            raise SyncError("pending repair backup directory is unsafe")
        backup_path = Path(backup).absolute()
        try:
            backup_resolved = backup_path.resolve(strict=True)
            backup_root_resolved = backup_root.resolve(strict=True)
        except OSError as exc:
            raise SyncError("pending repair backup cannot be resolved") from exc
        if not backup_resolved.is_relative_to(backup_root_resolved):
            raise SyncError("pending repair backup is outside backup directory")
        try:
            backup_stat = os.lstat(backup_path)
        except FileNotFoundError as exc:
            raise SyncError("pending repair backup is missing; manual review required") from exc
        if stat.S_ISLNK(backup_stat.st_mode) or not stat.S_ISREG(backup_stat.st_mode):
            raise SyncError("pending repair backup is not a regular file")
        # If the new bytes made it all the way to the expected hash, this is a
        # successful crash recovery point.  Otherwise restore the old inode.
        current = None
        try:
            current = md5_file(destination)[0]
        except (OSError, SyncError):
            pass
        if current == journal.get("new_md5"):
            self.report["actions"].append({"action": "clear_completed_journal", "path": path})
            try:
                self.journal_path.unlink()
            except FileNotFoundError:
                pass
            return
        if self.args.apply and current is not None:
            self._overwrite_existing(destination, backup_path, expected_md5=journal.get("old_md5"), journaled=False)
            self.report["actions"].append({"action": "restore_pending_repair", "path": path})
            self.journal_path.unlink()
        else:
            self.report["errors"].append({"kind": "pending_repair", "path": path})
            raise SyncError("pending repair requires --apply recovery")

    def _download_temp(self, client: Client, path: str, expected: Mapping[str, Any]) -> tuple[Path, str, int]:
        destination = safe_destination(self.root, path, create_parents=self.args.apply)
        parent = destination.parent
        if not parent.exists() and not self.args.apply:
            raise SyncError("would create destination parent")
        temp = parent / f".{destination.name}.xzz-sync-{secrets.token_hex(8)}.part"
        try:
            if self.args.max_bytes is not None:
                remaining = self.args.max_bytes - self.bytes_used
                if int(expected["size"]) > remaining:
                    raise SyncError("run byte bound reached")
            digest, size = client.stream_file(
                path, temp, expected_size=int(expected["size"]),
                max_seconds=self.remaining_seconds(),
                rate=self.args.rate, byte_budget=(None if self.args.max_bytes is None else self.args.max_bytes - self.bytes_used),
            )
            self.bytes_used += size
            accounted = True
            if digest != str(expected["md5"]).lower():
                raise SyncError("download MD5 disagrees with pinned hash")
            # Confirm the persisted bytes before linking or repairing anything.
            disk_md5, disk_size = md5_file(temp, max_seconds=self.remaining_seconds())
            if disk_md5 != digest or disk_size != size:
                raise SyncError("staged download changed after transfer")
            return temp, digest, size
        except Exception:
            if not locals().get("accounted", False):
                self.bytes_used += int(getattr(client, "last_bytes", 0))
            try:
                temp.unlink()
            except FileNotFoundError:
                pass
            raise

    def _backup_existing(self, path: Path, remote_path: str) -> Path:
        reserve = getattr(getattr(self, "args", None), "free_reserve_bytes", DEFAULT_FREE_RESERVE)
        try:
            if shutil.disk_usage(self.root).free < reserve + path.stat().st_size:
                raise SyncError("destination free-space reserve would be breached before backup")
        except OSError as exc:
            raise SyncError("could not inspect destination free space") from exc
        backup_root = self.root / ".xzz-sync-backups"
        try:
            backup_stat = os.lstat(backup_root)
            if stat.S_ISLNK(backup_stat.st_mode) or not stat.S_ISDIR(backup_stat.st_mode):
                raise SyncError("backup directory is not a real directory")
        except FileNotFoundError:
            backup_root.mkdir()
            backup_stat = os.lstat(backup_root)
            if stat.S_ISLNK(backup_stat.st_mode) or not stat.S_ISDIR(backup_stat.st_mode):
                raise SyncError("backup directory is not a real directory")
        # A random basename avoids exposing remote path punctuation and keeps
        # backups forever as requested.
        backup = backup_root / f"{int(time.time())}-{secrets.token_hex(12)}.bak"
        fd = os.open(path, os.O_RDONLY | getattr(os, "O_NOFOLLOW", 0))
        try:
            with os.fdopen(fd, "rb", closefd=True) as source, backup.open("xb") as target:
                shutil.copyfileobj(source, target, length=1024 * 1024)
                target.flush()
                os.fsync(target.fileno())
            dfd = os.open(backup_root, os.O_RDONLY)
            try:
                os.fsync(dfd)
            finally:
                os.close(dfd)
        except OSError as exc:
            try:
                backup.unlink()
            except FileNotFoundError:
                pass
            raise SyncError("backup write or directory fsync failed") from exc
        except Exception:
            try:
                backup.unlink()
            except FileNotFoundError:
                pass
            raise
        self._last_backup = backup
        return backup

    def _overwrite_existing(self, destination: Path, source: Path, *, expected_md5: str | None,
                            backup_path: Path | None = None, journaled: bool = True) -> None:
        before = stat_fingerprint(destination)
        if not expected_md5 or md5_file(source)[0] != expected_md5:
            raise SyncError("repair source checksum failed before overwrite")
        if journaled:
            if backup_path is None:
                backup_path = getattr(self, "_last_backup", None)
            if backup_path is None:
                raise SyncError("repair backup is required before overwrite")
            old_md5, _ = md5_file(destination)
            atomic_json(self.journal_path, {
                "schema": 1, "path": self._remote_for_destination(destination),
                "backup": str(backup_path), "old_md5": old_md5, "new_md5": expected_md5,
                "inode": before, "created_at": time.time(),
            })
        fd = os.open(destination, os.O_RDWR | getattr(os, "O_NOFOLLOW", 0))
        try:
            with os.fdopen(fd, "r+b", closefd=True) as target, source.open("rb") as incoming:
                target.seek(0)
                target.truncate(0)
                while True:
                    block = incoming.read(1024 * 1024)
                    if not block:
                        break
                    target.write(block)
                target.flush()
                os.fsync(target.fileno())
            after = stat_fingerprint(destination)
            # Content writes legitimately advance timestamps (and ctime); the
            # identity and access-control fields must remain exactly stable.
            for field in ("inode", "dev", "mode", "uid", "gid"):
                if after[field] != before[field]:
                    raise SyncError(f"existing file metadata changed during repair: {field}")
            if after["size"] != source.stat().st_size:
                raise SyncError("existing file size changed during repair")
            if md5_file(destination)[0] != expected_md5:
                raise SyncError("repaired file checksum failed; restoring backup")
        except Exception:
            if journaled:
                try:
                    self._restore_from_backup(destination, backup_path, before)
                except Exception as restore_exc:
                    raise SyncError("repair failed and backup restore failed") from restore_exc
            raise
        if journaled:
            self.journal_path.unlink(missing_ok=True)

    def _restore_from_backup(self, destination: Path, backup: Path, expected: Mapping[str, int]) -> None:
        current = stat_fingerprint(destination)
        if current["inode"] != expected["inode"] or current["dev"] != expected["dev"]:
            raise SyncError("refusing restore after inode changed")
        fd = os.open(destination, os.O_RDWR | getattr(os, "O_NOFOLLOW", 0))
        try:
            with os.fdopen(fd, "r+b", closefd=True) as target, backup.open("rb") as source:
                target.seek(0)
                target.truncate(0)
                shutil.copyfileobj(source, target, length=1024 * 1024)
                target.flush()
                os.fsync(target.fileno())
        finally:
            after = stat_fingerprint(destination)
            if after["inode"] != expected["inode"] or after["dev"] != expected["dev"]:
                raise SyncError("restore changed inode")

    def _remote_for_destination(self, destination: Path) -> str:
        return destination.absolute().relative_to(self.root).as_posix()

    def _refresh_after_changes(self, state: dict[str, Any]) -> None:
        changed = any(
            isinstance(item, dict) and item.get("action") in {"download", "repair"}
            for item in self.report["actions"]
        )
        pending = state.get("refresh_pending")
        if not self.args.apply:
            if pending:
                self.report["warnings"].append({"kind": "refresh_pending_dry_run"})
            return
        if not changed and not pending:
            return
        url = self.args.boardripper_url
        if not url:
            state["refresh_pending"] = {
                "reason": "missing_boardripper_url", "updated_at": time.time(),
            }
            self.report["warnings"].append({"kind": "refresh_pending", "reason": "missing_boardripper_url"})
            return
        try:
            result = BoardRipperRefresh(url, timeout=self.args.timeout).trigger()
        except SyncError:
            result = "failed"
        if result == "complete":
            state.pop("refresh_pending", None)
            self.report["actions"].append({"action": "boardripper_refresh", "status": "complete"})
        elif result == "running":
            state["refresh_pending"] = {"reason": "scan_running", "updated_at": time.time()}
            self.report["warnings"].append({"kind": "refresh_pending", "reason": "scan_running"})
            self.report["actions"].append({"action": "boardripper_refresh", "status": "running"})
        else:
            state["refresh_pending"] = {"reason": "hook_failed", "updated_at": time.time()}
            self.report["errors"].append({"kind": "refresh_pending", "reason": "hook_failed"})

    def run(self) -> dict[str, Any]:
        state = self.bootstrap_or_load()
        self.recover_journal()
        client = Client(self.args.base_url, load_credentials_path(self.args.credentials), timeout=self.args.timeout)
        # Every run fetches only the two catalog metadata objects.  SYNCING.md
        # is prose for humans and is intentionally not treated as health data.
        manifest = parse_manifest_bytes(client.get("manifest.txt", max_bytes=self.args.metadata_limit))
        hashes = parse_hashes_bytes(client.get("hashes.json", max_bytes=self.args.metadata_limit))
        manifest_set = set(manifest)
        hash_extras = sorted(set(hashes) - manifest_set)
        if hash_extras:
            self.report["hashes_outside_manifest"] = len(hash_extras)
            hashes = {path: value for path, value in hashes.items() if path in manifest_set}
        baseline_count = int(state.get("baseline_count", 0))
        if len(manifest) < baseline_count * (1.0 - self.args.catalog_drop_fraction):
            raise FrozenError("remote catalog dropped beyond safety threshold")
        pinned = state["pinned_hashes"]
        changed = {p: hashes[p] for p in set(pinned).intersection(hashes) if hashes[p] != pinned[p]}
        mass_threshold = max(self.args.mass_change_min, int(max(1, len(pinned)) * self.args.mass_change_fraction))
        if len(changed) >= mass_threshold:
            raise FrozenError("abnormal mass hash changes; sync frozen")
        self.report.update({"manifest_count": len(manifest), "hash_count": len(hashes), "changed_hashes": sorted(changed)})
        self.report["actions"].append({"action": "metadata_ok", "manifest_count": len(manifest), "hash_count": len(hashes), "ignored_hash_extras": len(hash_extras)})
        if changed:
            self.report["errors"].append({"kind": "review_hash_changes", "paths": sorted(changed)})

        cache = state.setdefault("verified_cache", {})
        baseline_set = set(state.get("baseline_manifest", []))
        missing_pinned = sorted(set(pinned) - manifest_set)
        if missing_pinned:
            self.report["warnings"].append({"kind": "pinned_paths_missing_from_manifest", "paths": missing_pinned})
        all_paths = sorted(manifest_set)
        if self.args.only_path:
            only = validate_remote_path(self.args.only_path)
            if only not in manifest_set:
                raise SyncError("--only-path is absent from the remote manifest")
            all_paths = [only]
        for path in all_paths:
            try:
                self.check_time()
            except SyncError as exc:
                self.report["actions"].append({"action": "deferred_time_budget", "message": str(exc)})
                self._checkpoint(state, cache, len(manifest))
                break
            if self.files_used >= self.args.max_files:
                break
            expected = hashes.get(path)
            pinned_expected = pinned.get(path)
            destination = safe_destination(self.root, path, create_parents=False)
            try:
                local_exists = destination.exists() or destination.is_symlink()
                if expected is None:
                    self.report["warnings"].append({"kind": "missing_remote_hash", "path": path})
                    continue
                # An existing pinned path whose remote hash moved is review-only.
                if path in changed:
                    self.report["errors"].append({"kind": "changed_remote_hash", "path": path, "pinned": pinned_expected, "remote": expected})
                    continue
                if not local_exists:
                    alias = state.get("aliases", {}).get(path)
                    if isinstance(alias, dict):
                        try:
                            alias_destination = safe_destination(self.root, alias["local_path"])
                            alias_fp = stat_fingerprint(alias_destination)
                            if (alias_fp["size"] == expected["size"] and alias_fp["mtime_ns"] == alias["mtime_ns"]
                                    and alias_fp["inode"] == alias["inode"] and alias.get("md5") == expected["md5"]):
                                cache[alias["local_path"]] = {**alias_fp, "md5": expected["md5"]}
                                self.report["actions"].append({"action": "alias_used", "path": path, "local_path": alias["local_path"]})
                                continue
                            self.report["errors"].append({"kind": "alias_review", "path": path, "local_path": alias.get("local_path")})
                            continue
                        except (KeyError, SyncError):
                            self.report["errors"].append({"kind": "alias_review", "path": path})
                            continue
                    if path in baseline_set and pinned_expected is None:
                        self.report["warnings"].append({"kind": "untrusted_baseline_hash", "path": path})
                        continue
                    self.files_used += 1
                    if self.args.apply:
                        self._ensure_free_space(int(expected["size"]))
                        temp, _, _ = self._download_temp(client, path, expected)
                        try:
                            destination = safe_destination(self.root, path, create_parents=True)
                            # The verified pin is durable before installation;
                            # a crash after this point can safely resume the
                            # idempotent missing-file install.
                            self._append_accepted_pin(path, expected)
                            pinned[path] = {"md5": expected["md5"], "size": expected["size"]}
                            try:
                                os.link(temp, destination, follow_symlinks=False)
                            except FileExistsError:
                                raise SyncError("destination appeared during download")
                            temp.unlink()
                            dfd = os.open(destination.parent, os.O_RDONLY)
                            try:
                                os.fsync(dfd)
                            finally:
                                os.close(dfd)
                            # A newly catalogued path is accepted only after
                            # this run verified its complete transfer.  It is
                            # then pinned so a later remote hash change is
                            # quarantined for review like every other path.
                            self._maybe_checkpoint(state, cache, len(manifest))
                            self.report["actions"].append({"action": "verified", "path": path, "source": "download"})
                            self.report["actions"].append({"action": "download", "path": path, "size": expected["size"]})
                        finally:
                            temp.unlink(missing_ok=True)
                    else:
                        self.report["actions"].append({"action": "would_download", "path": path, "size": expected["size"]})
                    continue
                if pinned_expected is None:
                    self.report["warnings"].append({"kind": "unverifiable_existing_file", "path": path})
                    continue
                fp = stat_fingerprint(destination)
                cached = cache.get(path)
                if isinstance(cached, dict) and all(cached.get(k) == fp[k] for k in ("size", "mtime_ns", "inode", "dev")):
                    local_md5 = cached.get("md5")
                else:
                    if self.args.max_checks is not None and self.checks_used >= self.args.max_checks:
                        self.report["actions"].append({"action": "deferred_check_budget", "path": path})
                        continue
                    self.checks_used += 1
                    self.files_used += 1
                    local_md5, local_size = md5_file(destination, max_seconds=self.remaining_seconds())
                    cache[path] = {**fp, "md5": local_md5, "size": local_size}
                    self._maybe_checkpoint(state, cache, len(manifest))
                if local_md5 == expected["md5"] and fp["size"] == expected["size"]:
                    self.report["actions"].append({"action": "verified", "path": path})
                    continue
                # Existing repairs are permitted only for hash-pinned paths.
                if pinned_expected.get("md5") != expected["md5"] or pinned_expected.get("size") != expected["size"]:
                    self.report["errors"].append({"kind": "review_unpinned_existing_mismatch", "path": path})
                    continue
                if self.args.apply:
                    self._ensure_free_space(int(expected["size"]) + int(destination.stat().st_size))
                    temp, _, _ = self._download_temp(client, path, expected)
                    backup = self._backup_existing(destination, path)
                    try:
                        self._overwrite_existing(destination, temp, expected_md5=expected["md5"], backup_path=backup)
                        self._maybe_checkpoint(state, cache, len(manifest))
                        self.report["actions"].append({"action": "repair", "path": path, "backup": str(backup)})
                    finally:
                        temp.unlink(missing_ok=True)
                else:
                    self.report["actions"].append({"action": "would_repair", "path": path, "size": expected["size"]})
            except SyncError as exc:
                self.report["errors"].append({"kind": "path_error", "path": path, "message": str(exc)})
                self._checkpoint(state, cache, len(manifest))
                if self.args.stop_on_error:
                    raise
        self._refresh_after_changes(state)
        self._checkpoint(state, cache, len(manifest))
        state["run_count"] = int(state.get("run_count", 0)) + 1
        state["updated_at"] = time.time()
        atomic_json(self.state_path, state)
        self.report.update({"finished_at": time.time(), "bytes": self.bytes_used, "files": self.files_used, "checks": self.checks_used})
        if not self.args.dry_report:
            receipt_dir = self.state_dir / "receipts"
            atomic_json(receipt_dir / f"{int(time.time())}-{secrets.token_hex(6)}.json", self.report)
        return self.report


def parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--base-url", default=os.environ.get("XZZ_BASE_URL", DEFAULT_BASE_URL))
    p.add_argument("--root", default=os.environ.get("XZZ_LIBRARY_ROOT", DEFAULT_ROOT))
    p.add_argument("--state-dir", default=os.environ.get("XZZ_STATE_DIR", DEFAULT_STATE_DIR))
    p.add_argument("--credentials")
    p.add_argument("--provided-manifest")
    p.add_argument("--provided-hashes")
    p.add_argument("--verified-aliases", help="root-verified aliases JSON used to avoid duplicate copies")
    p.add_argument("--boardripper-url", default=os.environ.get("BOARDRIPPER_URL"),
                   help="exact BoardRipper refresh hook URL")
    p.add_argument("--apply", action="store_true", help="enable downloads and repairs")
    p.add_argument("--max-files", type=int, default=100)
    p.add_argument("--max-checks", type=int, default=100,
                   help="maximum uncached local file hashes this run (cache hits are free)")
    p.add_argument("--checkpoint-every", type=int, default=100,
                   help="persist progress after this many verified files")
    p.add_argument("--only-path", help="process exactly one validated manifest path")
    p.add_argument("--max-bytes", type=int)
    p.add_argument("--free-reserve-bytes", type=int, default=DEFAULT_FREE_RESERVE,
                   help="minimum free bytes to retain on the destination filesystem")
    p.add_argument("--max-seconds", type=float, default=3600)
    p.add_argument("--rate", type=float, default=2 * 1024 * 1024)
    p.add_argument("--timeout", type=float, default=30)
    p.add_argument("--metadata-limit", type=int, default=256 * 1024 * 1024)
    p.add_argument("--catalog-drop-fraction", type=float, default=0.05)
    p.add_argument("--mass-change-fraction", type=float, default=0.05)
    p.add_argument("--mass-change-min", type=int, default=100)
    p.add_argument("--stop-on-error", action="store_true")
    p.add_argument("--dry-report", action="store_true", help="do not write a receipt")
    return p


def main(argv: list[str] | None = None) -> int:
    args = parser().parse_args(argv)
    if (args.free_reserve_bytes < 0 or args.max_files < 0 or args.max_checks is not None and args.max_checks < 0
            or args.checkpoint_every <= 0 or args.max_bytes is not None and args.max_bytes < 0):
        parser().error("bounds must be non-negative")
    try:
        report = SyncWorker(args).run()
    except FrozenError as exc:
        print(f"SYNC FROZEN: {exc}", file=sys.stderr)
        return 3
    except SyncError as exc:
        print(f"SYNC ERROR: {exc}", file=sys.stderr)
        return 2
    print(json.dumps({"dry_run": report["dry_run"], "files": report.get("files", 0), "checks": report.get("checks", 0), "bytes": report.get("bytes", 0), "errors": len(report.get("errors", [])), "warnings": len(report.get("warnings", []))}, sort_keys=True))
    return 0 if not report.get("errors") else 4


if __name__ == "__main__":
    raise SystemExit(main())
