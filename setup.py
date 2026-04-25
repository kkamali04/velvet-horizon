#!/usr/bin/env python3
"""
Velvet Horizon - Minecraft Server Setup Script
KAIDO / Cognesia Modded Minecraft Server (MC 1.21.1 | NeoForge | ATM10)

Usage:
    python setup.py
    python setup.py --mods-dir /path/to/mods
    python3 setup.py --mods-dir /custom/mods/path
"""

import argparse
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import urllib.error
import urllib.request
from pathlib import Path

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

MINECRAFT_VERSION = "1.21.1"
LOADER = "neoforge"

MODRINTH_API = "https://api.modrinth.com/v2"
MODRINTH_SLUGS = [
    "simple-voice-chat",
    "emotecraft",
    "chat-heads",
    "xaeros-minimap",
    "xaeros-world-map",
    "lightmans-currency",
    "automobility",
    "immersive-vehicles",
    "cobblemon",
    "mowzies-mobs",
    "create-aeronautics",
    "copycats",
    "create-new-age",
    "slice-and-dice",
    "create-power-loader",
    "enigmaticlegacy+",
    "distanthorizons",
    "creaturechat",
    "tacz-1.21.1",
    "create-steam-n-rails-1.21.1",
    "origins-neoforge",
    "create-design-n-decor",
]

ATLAUNCHER_DOWNLOADS = {
    "Windows": "https://github.com/ATLauncher/ATLauncher/releases/latest/download/ATLauncher-Windows.exe",
    "Darwin":  "https://github.com/ATLauncher/ATLauncher/releases/latest/download/ATLauncher-macOS.dmg",
    "Linux":   "https://github.com/ATLauncher/ATLauncher/releases/latest/download/ATLauncher-Linux.AppImage",
}

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

BOLD  = "\033[1m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED   = "\033[31m"
CYAN  = "\033[36m"
RESET = "\033[0m"

# Windows cmd.exe doesn't support ANSI by default before Win10 1511
if platform.system() == "Windows":
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
    except Exception:
        BOLD = GREEN = YELLOW = RED = CYAN = RESET = ""


def info(msg: str) -> None:
    print(f"{CYAN}[INFO]{RESET}  {msg}")


def ok(msg: str) -> None:
    print(f"{GREEN}[OK]{RESET}    {msg}")


def warn(msg: str) -> None:
    print(f"{YELLOW}[WARN]{RESET}  {msg}")


def error(msg: str) -> None:
    print(f"{RED}[ERROR]{RESET} {msg}", file=sys.stderr)


def heading(msg: str) -> None:
    width = 60
    print()
    print(f"{BOLD}{CYAN}{'=' * width}{RESET}")
    print(f"{BOLD}{CYAN}  {msg}{RESET}")
    print(f"{BOLD}{CYAN}{'=' * width}{RESET}")
    print()


def fetch_json(url: str) -> dict:
    """Fetch a URL and parse as JSON. Raises on HTTP error."""
    req = urllib.request.Request(url, headers={"User-Agent": "VelvetHorizon-Setup/1.0"})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode())


def download_file(url: str, dest: Path, label: str = "") -> bool:
    """Download url to dest, printing a simple progress indicator."""
    label = label or dest.name
    req = urllib.request.Request(url, headers={"User-Agent": "VelvetHorizon-Setup/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            total = int(resp.headers.get("Content-Length", 0))
            downloaded = 0
            chunk = 65536
            with open(dest, "wb") as fh:
                while True:
                    buf = resp.read(chunk)
                    if not buf:
                        break
                    fh.write(buf)
                    downloaded += len(buf)
                    if total:
                        pct = downloaded * 100 // total
                        print(f"\r    {label}: {pct}%", end="", flush=True)
            print()  # newline after progress
        return True
    except urllib.error.HTTPError as exc:
        print()
        warn(f"HTTP {exc.code} downloading {label} — skipping")
        return False
    except urllib.error.URLError as exc:
        print()
        warn(f"Network error downloading {label}: {exc.reason} — skipping")
        return False


# ---------------------------------------------------------------------------
# Step 1 — Python version check
# ---------------------------------------------------------------------------

def check_python() -> None:
    heading("Step 1 — Python Version")
    major, minor = sys.version_info[:2]
    if (major, minor) < (3, 8):
        error(f"Python 3.8+ required; you have {major}.{minor}")
        sys.exit(1)
    ok(f"Python {major}.{minor} detected")


# ---------------------------------------------------------------------------
# Step 2 — Java 21+ check
# ---------------------------------------------------------------------------

def check_java() -> None:
    heading("Step 2 — Java Version")
    java_bin = shutil.which("java")
    if java_bin is None:
        warn("Java not found on PATH.")
        _print_java_install_hint()
        return

    try:
        result = subprocess.run(
            ["java", "-version"],
            capture_output=True,
            text=True,
            timeout=10,
        )
        # java -version prints to stderr
        output = result.stderr or result.stdout
        match = re.search(r'version "(\d+)(?:\.(\d+))?', output)
        if match:
            major = int(match.group(1))
            # Old-style versioning: 1.8 → 8
            if major == 1 and match.group(2):
                major = int(match.group(2))
            if major >= 21:
                ok(f"Java {major} detected at {java_bin}")
            else:
                warn(f"Java {major} detected but Minecraft 1.21.1 requires Java 21+.")
                _print_java_install_hint()
        else:
            warn(f"Could not parse Java version from: {output.strip()!r}")
    except subprocess.TimeoutExpired:
        warn("Java version check timed out.")
    except Exception as exc:
        warn(f"Error checking Java: {exc}")


def _print_java_install_hint() -> None:
    print()
    print("  Install Java 21 from one of:")
    print("    - Adoptium (recommended): https://adoptium.net/temurin/releases/?version=21")
    print("    - Oracle JDK 21:          https://www.oracle.com/java/technologies/downloads/#java21")
    print()


# ---------------------------------------------------------------------------
# Step 3 — ATLauncher download hint
# ---------------------------------------------------------------------------

def check_atlauncher(mods_dir: Path) -> None:
    heading("Step 3 — ATLauncher")
    system = platform.system()

    # Heuristic: if the mods_dir path contains 'ATLauncher', assume it's installed
    if "ATLauncher" in str(mods_dir):
        ok("ATLauncher directory detected in mods path — assuming installed.")
        return

    url = ATLAUNCHER_DOWNLOADS.get(system)
    if url:
        info(f"Download ATLauncher for {system}:")
        print(f"    {url}")
    else:
        info("Download ATLauncher from: https://atlauncher.com/downloads")
    print()
    info("After installing ATLauncher, create a new instance:")
    print("    1. Open ATLauncher → Packs tab")
    print("    2. Search for 'All the Mods 10' (ATM10)")
    print("    3. Click New Instance → select latest 1.21.1 version → Install")
    print()


# ---------------------------------------------------------------------------
# Step 4 — Instance directory structure
# ---------------------------------------------------------------------------

def create_instance_dirs(mods_dir: Path) -> None:
    heading("Step 4 — Instance Directory Structure")
    dirs = [
        mods_dir,
        mods_dir.parent / "config",
        mods_dir.parent / "resourcepacks",
        mods_dir.parent / "shaderpacks",
        mods_dir.parent / "screenshots",
    ]
    for d in dirs:
        d.mkdir(parents=True, exist_ok=True)
        ok(f"Ensured: {d}")


# ---------------------------------------------------------------------------
# Step 5 — Download mods from Modrinth
# ---------------------------------------------------------------------------

def resolve_modrinth_version(slug: str) -> tuple[str, str] | None:
    """
    Return (download_url, filename) for the best version of a mod matching
    MINECRAFT_VERSION and LOADER (neoforge), falling back to forge if needed.
    Returns None if nothing suitable is found.
    """
    loaders_to_try = [LOADER, "forge", "fabric"]

    try:
        versions_url = (
            f"{MODRINTH_API}/project/{slug}/version"
            f"?game_versions=%5B%22{MINECRAFT_VERSION}%22%5D"
        )
        versions = fetch_json(versions_url)
    except Exception as exc:
        warn(f"  Could not fetch versions for {slug!r}: {exc}")
        return None

    if not versions:
        warn(f"  No versions found for {slug!r} on MC {MINECRAFT_VERSION}")
        return None

    # Try preferred loaders in order
    for loader in loaders_to_try:
        for version in versions:
            if loader in version.get("loaders", []):
                files = version.get("files", [])
                primary = next((f for f in files if f.get("primary")), files[0] if files else None)
                if primary:
                    return primary["url"], primary["filename"]

    # Fall through — grab the first available file regardless of loader
    for version in versions:
        files = version.get("files", [])
        primary = next((f for f in files if f.get("primary")), files[0] if files else None)
        if primary:
            return primary["url"], primary["filename"]

    return None


def download_mods(mods_dir: Path) -> None:
    heading("Step 5 — Downloading Custom Mods from Modrinth")
    info(f"Target directory: {mods_dir}")
    print()

    success_count = 0
    skip_count = 0
    fail_count = 0

    for slug in MODRINTH_SLUGS:
        info(f"Resolving {slug!r} ...")
        result = resolve_modrinth_version(slug)
        if result is None:
            warn(f"  Skipping {slug!r} — no compatible version found")
            fail_count += 1
            continue

        url, filename = result
        dest = mods_dir / filename

        if dest.exists():
            ok(f"  Already downloaded: {filename}")
            skip_count += 1
            continue

        downloaded = download_file(url, dest, label=filename)
        if downloaded:
            ok(f"  Saved: {filename}")
            success_count += 1
        else:
            fail_count += 1

    print()
    info(f"Mods downloaded: {success_count}  |  Already present: {skip_count}  |  Failed/skipped: {fail_count}")


# ---------------------------------------------------------------------------
# Step 6 — Finish-setup instructions
# ---------------------------------------------------------------------------

def print_finish_instructions(mods_dir: Path) -> None:
    heading("Setup Complete — Final Steps in ATLauncher")
    steps = [
        "Open ATLauncher and go to the Instances tab.",
        "Find your ATM10 / VelvetHorizon instance.",
        "Click 'Edit Mods' to confirm the custom mods are listed.",
        "Click Play to launch the instance.",
        "On the Minecraft main screen, click Multiplayer.",
        "Click Add Server and enter the Velvet Horizon IP.",
        "Server IP: [Coming Soon — check Discord for the live address]",
        "Discord:   https://discord.gg/sM8yXGRQ",
    ]
    for i, step in enumerate(steps, 1):
        print(f"  {BOLD}{i}.{RESET} {step}")
    print()
    ok("Enjoy Velvet Horizon!")
    print()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def default_mods_dir() -> Path:
    system = platform.system()
    if system == "Windows":
        appdata = os.environ.get("APPDATA", str(Path.home() / "AppData" / "Roaming"))
        return Path(appdata) / "ATLauncher" / "instances" / "VelvetHorizon" / "mods"
    elif system == "Darwin":
        return Path.home() / "Library" / "Application Support" / "ATLauncher" / "instances" / "VelvetHorizon" / "mods"
    else:  # Linux / other
        return Path.home() / ".atlauncher" / "instances" / "VelvetHorizon" / "mods"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Velvet Horizon — one-shot Minecraft client setup",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        "--mods-dir",
        metavar="PATH",
        type=Path,
        default=None,
        help=(
            "Directory to save mod JARs into. "
            "Defaults to the platform-specific ATLauncher mods folder."
        ),
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    mods_dir: Path = args.mods_dir or default_mods_dir()

    print()
    print(f"{BOLD}{CYAN}  Velvet Horizon — Minecraft Client Setup{RESET}")
    print(f"  KAIDO / Cognesia | MC {MINECRAFT_VERSION} | NeoForge | ATM10")
    print()

    check_python()
    check_java()
    check_atlauncher(mods_dir)
    create_instance_dirs(mods_dir)
    download_mods(mods_dir)
    print_finish_instructions(mods_dir)


if __name__ == "__main__":
    main()
