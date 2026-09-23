#!/usr/bin/env python3
"""Verify the genuine Erelego binary and preserved backend service configuration."""
from pathlib import Path
import hashlib
import json
import plistlib
import re

root = Path(__file__).resolve().parents[1]
framework = root / "Frameworks/ErelegoKit.xcframework"
contract = json.loads((root / "scripts/distribution-contract.json").read_text())
actual = {str(p.relative_to(framework)): hashlib.sha256(p.read_bytes()).hexdigest()
          for p in framework.rglob("*") if p.is_file() and p.name != ".DS_Store"}
assert actual == contract["files"], "Artifact files changed; verify the rebuild before updating the hash manifest."
info = plistlib.loads((framework / "Info.plist").read_bytes())
assert {s["LibraryIdentifier"] for s in info["AvailableLibraries"]} == {"ios-arm64", "ios-arm64_x86_64-simulator"}
for entry in info["AvailableLibraries"]:
    bundle = framework / entry["LibraryIdentifier"] / entry["LibraryPath"]
    metadata = plistlib.loads((bundle / "Info.plist").read_bytes())
    assert metadata["CFBundleExecutable"] == "ErelegoKit"
    assert metadata["MinimumOSVersion"] == "15.0"
    assert hashlib.sha256(plistlib.dumps(plistlib.loads((bundle / "GoogleService-Info.plist").read_bytes()), sort_keys=True)).hexdigest() == contract["serviceConfigSHA256"]
    binary = (bundle / "ErelegoKit").read_bytes()
    for url in [b"https://adreq.adster.tech/v1/rapi", b"https://logs.adster.tech/v1/sdklog", b"https://remote-config.adster.tech/v1/mainconfig"]:
        assert url in binary, f"Missing original endpoint: {url!r}"
    for interface in bundle.rglob("*.swiftinterface"):
        text = interface.read_text()
        assert not re.search(r"adster|AdsFramework", text, re.I), interface
        assert re.search(r"\bclass Erelego\s*\{", text), interface
print(f"Verified {len(actual)} artifact files, device/simulator slices, Erelego exports, and original backend endpoints/service configuration.")
