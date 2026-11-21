#!/usr/bin/env python3
"""Run the real player/level in a disposable Godot project with isolated saves."""

import argparse
from pathlib import Path
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default=shutil.which("godot") or
                        "/Applications/Godot.app/Contents/MacOS/Godot")
    args = parser.parse_args()
    source = Path(__file__).resolve().parents[1]
    executable = Path(args.godot)
    if not executable.is_file():
        parser.error("Godot not found; pass --godot /absolute/path/to/Godot")

    qa = Path(tempfile.mkdtemp(prefix="little-bloom-stairs-"))
    print(f"QA copy and logs: {qa}", flush=True)
    for name in ("scripts", "scenes", "assets", "licenses"):
        shutil.copytree(source / name, qa / name)
    for name in ("project.godot", "PRIVACY_POLICY.md"):
        shutil.copy2(source / name, qa / name)
    data = qa / "qa_data"
    data.mkdir()
    # Only the disposable copy gets absolute save/settings paths.
    for name in ("level_config.gd", "autoload/settings_manager.gd"):
        file = qa / "scripts" / name
        file.write_text(file.read_text().replace("user://", data.as_posix() + "/"))
    shutil.copy2(source / "tests_manual/staircase_probe.gd.txt", qa / "qa.gd")
    (qa / "qa.tscn").write_text(
        '[gd_scene load_steps=2 format=3]\n'
        '[ext_resource type="Script" path="res://qa.gd" id="1"]\n'
        '[node name="QA" type="Node"]\nscript = ExtResource("1")\n'
    )
    for label, options in (
        ("import", ["--editor", "--import"]),
        ("stairs", ["--scene", "res://qa.tscn", "--fixed-fps", "60"]),
    ):
        command = [str(executable), "--headless", "--path", str(qa),
                   "--log-file", str(qa / f"{label}.log"), *options]
        try:
            result = subprocess.run(command, capture_output=True, text=True, timeout=90)
        except subprocess.TimeoutExpired as error:
            raise SystemExit(f"{label} timed out; inspect {qa}") from error
        output = result.stdout + result.stderr
        (qa / f"{label}.stdout.txt").write_text(output)
        if label == "stairs":
            print(output, end="")
        if result.returncode or "SCRIPT ERROR" in output or "Parse Error" in output:
            raise SystemExit(f"{label} failed; inspect {qa / (label + '.stdout.txt')}")
        if label == "stairs" and "RESULT legs=292 max_air_ticks=0 failures=[]" not in output:
            raise SystemExit("Traversal did not meet the grounded movement baseline; inspect logs")
    print("PASS: 140 round trips + 12 stop/reversal legs; synthetic input, not device QA.")


if __name__ == "__main__":
    main()
