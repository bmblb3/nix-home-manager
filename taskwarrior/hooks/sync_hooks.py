from __future__ import annotations

import subprocess
import sys
import time
from pathlib import Path

SYNC_INTERVAL_SECONDS = 5
LOCK_STALE_AFTER_SECONDS = 10


def parse_state_dir(argv: list[str]) -> Path:
    for arg in argv:
        if arg.startswith("data:"):
            _, _, path = arg.partition(":")
            if path:
                return Path(path)
            break
    raise ValueError("missing data:<path> argument from Taskwarrior")


def should_sync(filestamp_path: Path, now: float) -> bool:
    try:
        last_run = float(filestamp_path.read_text().strip())
    except (FileNotFoundError, ValueError):
        return True
    return (now - last_run) >= SYNC_INTERVAL_SECONDS


def acquire_lock(lock_path: Path, state_dir: Path, now: float) -> bool:
    state_dir.mkdir(parents=True, exist_ok=True)
    try:
        lock_path.touch(exist_ok=False)
        return True
    except FileExistsError:
        try:
            mtime = lock_path.stat().st_mtime
        except FileNotFoundError:
            return False
        if now - mtime > LOCK_STALE_AFTER_SECONDS:
            try:
                lock_path.unlink()
            except FileNotFoundError:
                return False
            try:
                lock_path.touch(exist_ok=False)
                return True
            except FileExistsError:
                return False
        return False


def release_lock(lock_path: Path) -> None:
    try:
        lock_path.unlink()
    except FileNotFoundError:
        pass


def run_sync() -> int:
    result = subprocess.run(["task", "rc.hooks=0", "sync"])
    if result.returncode != 0:
        _ = sys.stderr.write(f"task sync failed with exit code {result.returncode}\n")
    return result.returncode


def maybe_run_sync(state_dir: Path, filestamp_name: str, lock_name: str) -> int:
    now = time.time()
    filestamp_path = state_dir / filestamp_name
    lock_path = state_dir / lock_name
    if not should_sync(filestamp_path, now):
        return 0
    if not acquire_lock(lock_path, state_dir, now):
        return 0
    try:
        _ = filestamp_path.write_text(str(now))
        return run_sync()
    finally:
        release_lock(lock_path)
