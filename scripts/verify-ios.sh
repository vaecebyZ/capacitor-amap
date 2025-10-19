#!/usr/bin/env bash
set -euo pipefail
cd ios
pod install --silent
# Prefer real device SDK if installed and usable
if xcodebuild -showsdks | grep -q iphoneos; then
  echo '[verify:ios] Detected iphoneos SDK. Attempt generic device build.'
  if xcodebuild -workspace Plugin.xcworkspace -scheme Plugin -configuration Release -sdk iphoneos -destination 'generic/platform=iOS' SUPPORTS_MACCATALYST=NO ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=NO build; then
    echo '[verify:ios] Device SDK build succeeded.'
    cd ..
    exit 0
  else
    echo '[verify:ios] Device SDK build failed; falling back to simulator.'
  fi
fi
SIM_JSON=$(xcrun simctl list devices -j)
SIM_ID=$(echo "$SIM_JSON" | python3 -c 'import json,sys; j=json.load(sys.stdin);\n# choose first shutdown iPhone with an installed OS version\nfor arr in j.get("devices",{}).values():\n  for d in arr:\n    if d.get("isAvailable") and d.get("name","" ).startswith("iPhone") and d.get("state") == "Shutdown":\n      print(d["udid"]); sys.exit(0)\nprint("")')
if [ -z "$SIM_ID" ]; then
  echo '[verify:ios] No suitable iPhone simulator found. Skipping iOS build.'
  cd ..
  exit 0
fi
# Boot simulator (ignore errors if already booted)
xcrun simctl boot "$SIM_ID" || true
# Build against that simulator id
xcodebuild -workspace Plugin.xcworkspace -scheme Plugin -configuration Release -sdk iphonesimulator -destination "id=$SIM_ID" ONLY_ACTIVE_ARCH=YES CODE_SIGNING_ALLOWED=NO build || { echo '[verify:ios] Simulator build failed.'; cd ..; exit 70; }
cd ..
