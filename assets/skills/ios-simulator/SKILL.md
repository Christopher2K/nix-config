---
name: iOS Simulator
description: Use when building, launching, inspecting, or testing iOS apps in Simulator on macOS, including xcrun simctl automation and SimSlim memory optimization.
---

# iOS Simulator

Use Xcode's `xcrun simctl` for simulator lifecycle and app automation, an available UI automation tool for interaction, and SimSlim when lower simulator memory usage is useful. Always target an exact simulator UDID and verify the app on screen, not just from a successful build or launch command.

The installed tools are the authority for current syntax:

```bash
xcrun simctl help
xcrun simctl help <subcommand>
simslim --help
simslim version
```

## 1. Discover and select a simulator

Require macOS, a working Xcode selection, and an installed iOS Simulator runtime. Do not install Xcode, download a runtime, or install SimSlim without the user's approval.

```bash
xcode-select -p
xcrun simctl list devices
xcrun simctl list devices --json
command -v simslim >/dev/null && simslim list
```

Choose an available device that matches the requested model and OS. If the user did not specify one, prefer an existing suitable device over creating another. Record its UDID and use it consistently:

```bash
export UDID="DEVICE_UDID"
xcrun simctl bootstatus "$UDID" -b
```

`bootstatus -b` boots the device when necessary and waits until it is ready. Simulator can run headlessly. Open the visible app only when a window is useful:

```bash
open -a Simulator
```

Avoid the special `booted` device selector when more than one simulator may be running: `simctl` then chooses one arbitrarily. Do not guess a UDID from a device name or reuse one from an earlier session without checking that it still exists.

## 2. Decide whether to slim

For an ordinary single-simulator workflow, stock services are the safest default. Use SimSlim when the user asks for it, several simulators must run concurrently, or simulator memory pressure is part of the task. Slimming deliberately disables features and normally reboots the selected simulator, so do not apply it blindly to a simulator already in use.

Inspect categories and required capabilities before changing state:

```bash
simslim profiles
simslim doctor --list
```

Slim one simulator and reboot it:

```bash
simslim on "$UDID"
```

For an already booted simulator when avoiding a reboot matters:

```bash
simslim on "$UDID" --no-reboot
```

Persistent overrides require iOS 18.5 or newer. On older runtimes, use `--no-reboot` after every boot; SimSlim rejects unsupported persistent changes rather than claiming success. Restoring stock services also reboots:

```bash
simslim off "$UDID"
```

### Preserve features the app needs

Keep whole categories with `--except`, or individual launchd services with `--keep`:

```bash
simslim on "$UDID" --except search,store,web,photos
simslim on "$UDID" --keep com.apple.apsd
```

Common dependencies include:

- Push notifications and StoreKit: `store` (`com.apple.apsd`, `com.apple.storekitd`).
- Universal links: `web` (`com.apple.swcd`).
- Spotlight, Settings search, and Files Recents: `search`.
- iCloud and keychain sync: `icloud`.
- Photo pickers and Photos-library workflows: `photos`.
- HealthKit or HomeKit: `health`.
- MDM: `mdm`; App Clips and accessibility asset downloads: `other`.

Check the actual categories and feature IDs instead of relying on this summary. After booting, validate required features and memory:

```bash
simslim status "$UDID"
simslim doctor "$UDID" --requires push,storekit,universal-links
simslim measure "$UDID"
```

`status` reports managed launchd-label state, not total process count. `measure` reports simulator memory footprint; do not compare it with a sum of process RSS values.

### Use a repeatable profile

For CI or repeatable development, keep a JSON profile with the project when requested:

```json
{
  "name": "ci",
  "description": "UI tests that exercise purchases and universal links",
  "except": ["store", "web"],
  "keep": []
}
```

```bash
simslim on "$UDID" --profile ci.json
simslim verify "$UDID" --profile ci.json
```

`--profile` cannot be combined with `--except` or `--keep`. `verify` exits non-zero on drift; erase, recreation, and runtime changes can silently return a simulator to stock service state.

Temporarily restore a category or daemon without rebooting:

```bash
simslim enable "$UDID" icloud,photos
simslim disable "$UDID" icloud
```

These live changes do not update the profile by default. Add `--save dev.json` when the change should persist in that profile. Return to the profile without rebooting with `simslim on "$UDID" --no-reboot --profile dev.json`.

For repeated parallel testing, `simslim watch --profile ci.json` can slim new devices and `xcodebuild` testing clones. Treat watch as an explicit long-running job and stop it when finished. It also writes the profile into shut-down simulators in its watched device sets; it is not a read-only monitor. Wait for its `slimmed` event before temporarily enabling services on a watched boot.

## 3. Build, install, and launch the app

Prefer the project's existing build workflow for SwiftPM, Xcode, React Native, Flutter, or another framework. Ensure the build targets an iOS Simulator SDK and the selected destination, not a physical device.

For a native Xcode project, adapt the workspace/project, scheme, app name, and output directory:

```bash
xcodebuild \
  -workspace App.xcworkspace \
  -scheme App \
  -configuration Debug \
  -destination "platform=iOS Simulator,id=$UDID" \
  -derivedDataPath .build/DerivedData \
  build
```

Use `-project App.xcodeproj` instead of `-workspace` when appropriate. With that derived-data path, a typical app bundle is `.build/DerivedData/Build/Products/Debug-iphonesimulator/App.app`; locate the actual bundle rather than assuming its name.

Install and read its real bundle identifier:

```bash
export APP_PATH="/path/to/App.app"
export ARTIFACT_DIR="$(mktemp -d)"
export BUNDLE_ID=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP_PATH/Info.plist")
xcrun simctl install "$UDID" "$APP_PATH"
xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE_ID"
```

The launch command prints a PID, not proof that the UI is correct. To capture standard output and error, place the options before the device:

```bash
xcrun simctl launch \
  --stdout="$ARTIFACT_DIR/app.stdout.log" \
  --stderr="$ARTIFACT_DIR/app.stderr.log" \
  "$UDID" "$BUNDLE_ID"
```

Use `--console` instead when a blocking attached process is desirable. Prefix launch environment variables with `SIMCTL_CHILD_`:

```bash
SIMCTL_CHILD_API_BASE_URL=http://127.0.0.1:3000 \
  xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE_ID"
```

Useful app inspection commands:

```bash
xcrun simctl appinfo "$UDID" "$BUNDLE_ID"
xcrun simctl get_app_container "$UDID" "$BUNDLE_ID" data
xcrun simctl terminate "$UDID" "$BUNDLE_ID"
```

## 4. Interact and verify visually

If the `agent-device` tools are available, use them for UI automation. For a known app, open it directly with its bundle identifier, target UDID, and `foreground: true`; do not probe devices or take screenshots first. Continue from the returned snapshot, use refs or selectors before coordinates, settle interactions, and verify expected text or state. Follow the tool's session protocol and close the session when done.

If no UI automation tool is available, use the project's XCUITest/UI-test workflow or ask the user to perform interactions. Do not simulate taps by guessing screen coordinates.

Capture evidence with `simctl`, then read the generated image before reporting visual success:

```bash
xcrun simctl io "$UDID" screenshot "$ARTIFACT_DIR/simulator.png"
```

Store generated screenshots, videos, and logs in the project's designated artifact/temp directory or a fresh temporary directory, not arbitrarily in source directories. A successful build, install, launch, or test process alone is not visual verification.

## 5. Exercise simulator capabilities

Use the exact UDID for every command. Consult `xcrun simctl help <subcommand>` for runtime-specific options.

```bash
# Appearance, contrast, and Dynamic Type
xcrun simctl ui "$UDID" appearance dark
xcrun simctl ui "$UDID" increase_contrast enabled
xcrun simctl ui "$UDID" content_size accessibility-extra-extra-large

# Deep links and universal links
xcrun simctl openurl "$UDID" 'myapp://path?value=1'

# Permissions (valid usage-description keys are still required in the real app)
xcrun simctl privacy "$UDID" grant photos "$BUNDLE_ID"
xcrun simctl privacy "$UDID" reset location "$BUNDLE_ID"

# Media and location
xcrun simctl addmedia "$UDID" photo.jpg
xcrun simctl location "$UDID" set 37.3349,-122.0090
xcrun simctl location "$UDID" clear

# Deterministic status bar for screenshots
xcrun simctl status_bar "$UDID" override \
  --time '9:41' --batteryState charged --batteryLevel 100 \
  --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4
xcrun simctl status_bar "$UDID" clear

# Unified logs, filtered to the app's real subsystem
xcrun simctl spawn "$UDID" log stream --level debug \
  --predicate 'subsystem == "com.example.app"'
```

Simulate a remote notification with a JSON payload containing `aps`:

```bash
xcrun simctl push "$UDID" "$BUNDLE_ID" notification.apns
```

Remember that push requires the relevant services to be enabled when using SimSlim. Granting permissions with `simctl` can mask missing or incorrect app permission flows, so also test the prompt path when that behavior matters.

## 6. Finish safely

- Report the device, runtime, build/test result, interactions performed, and remaining limitations.
- Leave the app and simulator in a useful state unless the user requested cleanup.
- Shut down only simulators you created for the task, unless the user asks otherwise: `xcrun simctl shutdown "$UDID"` or `simslim shutdown "$UDID"`.
- Ask before erase, delete, `disk-clean`, or other destructive operations. `simslim disk-plan` is the read-only way to inspect reclaimable data first.
- Do not kill host CoreSimulator services as a routine fix. Diagnose the exact simulator and error first.
- On slow CI runners, increase SimSlim's `--boot-timeout` or `--spawn-timeout` when its diagnostics indicate a timeout rather than blindly retrying a partially applied operation.

SimSlim reference: <https://github.com/MobAI-App/simslim>.
