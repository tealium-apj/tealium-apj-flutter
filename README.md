This repository is a Flutter example app demonstrating integration with the Tealium Flutter plugin.
NOT THE OFFICIAL TEALIUM REPO

The README below outlines quick, ordered steps to run the app on Android and iOS from macOS.

## Prerequisites (installation steps for macOS)

Below are concrete steps to install the required tools on macOS. If you already have these installed, run the verification steps at the end.

1) Homebrew (package manager)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Add Homebrew to your PATH if the installer instructs you to
```

2) Flutter SDK

- Recommended: install via Homebrew or follow the official instructions.

Homebrew (recommended):

```bash
brew install --cask flutter
```

Or follow the official install guide: https://docs.flutter.dev/get-started/install/macos

After installation, ensure Flutter is in your PATH. If installed via Homebrew, add:

```bash
export PATH="$PATH:/opt/homebrew/Caskroom/flutter/latest/flutter/bin"
```

3) Android Studio & Android SDK

- Option A — Full Android Studio (GUI)

	- Download and install Android Studio: https://developer.android.com/studio
	- Open Android Studio → SDK Manager and install the Android SDK (recommended API 33 or latest stable), and the Android SDK Platform-Tools.

- Option B — CLI-only (command-line tools + sdkmanager)

	If you prefer not to install the full Android Studio, you can install only the command-line SDK tools and manage SDK packages with `sdkmanager`.

	1. Install Android command-line tools via Homebrew Cask:

	```bash
	brew install --cask android-sdk
	# or the newer command-line tools package
	brew install --cask android-commandlinetools
	```

	2. Create an `ANDROID_SDK_ROOT` directory and accept licenses and install platforms:

	```bash
	mkdir -p $HOME/Library/Android/sdk
	export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
	export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools"

	# Install platform tools, emulator, and a platform (example API 33)
	sdkmanager --install "platform-tools" "platforms;android-33" "emulator"

	# Accept licenses
	yes | sdkmanager --licenses
	```

	3. Add these environment variables to your `~/.zshrc` (or shell profile):

	```bash
	export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
	export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator"
	```

	Note: `brew install --cask android-sdk` may be deprecated depending on Homebrew and Android tooling changes — if so, prefer downloading the command-line tools from the Android developer site and extracting into `$ANDROID_SDK_ROOT/cmdline-tools/latest/`.

4) Xcode (for iOS)

- Install from the App Store or https://developer.apple.com/xcode/
- After install, open Xcode once and accept licenses. Also install Xcode command line tools:

```bash
xcode-select --install
sudo xcodebuild -license
```

5) CocoaPods (iOS dependency manager)

Install via Homebrew (preferred) or Ruby gem:

Homebrew:

```bash
brew install cocoapods
```

Ruby gem:

```bash
sudo gem install cocoapods
```

6) Verify installation with Flutter doctor

```bash
flutter doctor -v
```

Follow any remediation steps `flutter doctor` prints (missing SDKs, licenses, or Xcode/Android Studio setup).

7) Tealium plugin

The Tealium plugin is declared in `pubspec.yaml`. Run `flutter pub get` to install the Dart plugin. Native platform code (iOS pods) will be prepared later when running `pod install` in the `ios/` folder.

```bash
flutter pub get
```

If you run into issues during plugin install or native builds, try `flutter clean` then `flutter pub get` and re-run the relevant platform steps.

## Setup (one-time)

1. From the project root, fetch Dart/Flutter dependencies:

```bash
flutter pub get
```

2. iOS only: install CocoaPods for the iOS workspace (from the `ios/` folder):

```bash
cd ios
pod install
cd ..
```

Note: If you see warnings about `.symlinks` or plugin linking, run `flutter clean` and then `flutter pub get` again.

## Configure Tealium credentials

The example app uses placeholder values in `lib/main.dart` for the Tealium account/profile/env. Replace them before testing with real values.

Open `lib/main.dart` and update the Tealium config values:

- `your_account` -> your Tealium account
- `your_profile` -> your Tealium profile
- `TealiumEnvironment.dev` -> dev/qa/prod as appropriate

The relevant section in `lib/main.dart` looks like:

```dart
final config = TealiumConfig(
	"your_account",
	"your_profile",
	TealiumEnvironment.dev,
	[Collectors.AppData, Collectors.Lifecycle],
	[Dispatchers.RemoteCommands, Dispatchers.Collect],
);
```

## Run on Android (emulator or device)

1. Start an Android emulator from Android Studio or connect a physical device with USB debugging enabled.

2. From project root, run:

```bash
flutter run -d <device-id>
```

You can list available devices with:

```bash
flutter devices
```

If you run into build errors, try:

```bash
flutter clean
flutter pub get
flutter run
```

## Run on iOS (simulator or device)

1. Open the iOS simulator via Xcode or connect a physical device.

2. If you're running on a physical device, ensure provisioning and code signing are configured in Xcode.

3. From project root, run:

```bash
flutter run -d <device-id>
```

Or open `ios/Runner.xcworkspace` in Xcode and run from there (useful to manage signing or pods).

If you hit CocoaPods issues, try:

```bash
cd ios
pod repo update
pod install
cd ..
flutter clean
flutter pub get
```

## Quick test

- Launch the app on a device/simulator.
- Tap the "Send Event" button on the example home screen to trigger a `TealiumEvent`.
- Verify events in your Tealium instance / remote commands as configured.

## Troubleshooting

- Missing plugin or build errors after upgrading Flutter: run `flutter clean`, then `flutter pub get`, and re-run the app.
- iOS build errors related to signing: open `ios/Runner.xcworkspace` in Xcode and configure a signing team for the Runner target.
- CocoaPods version conflicts: update CocoaPods and run `pod install` again.
- If Tealium native dependencies fail to link, ensure the plugin versions in `pubspec.yaml` and the Podfile lock are consistent. Removing `ios/Pods`, `ios/Podfile.lock` and running `pod install` can help.

## Notes

- This repository includes an example plugin integration; the plugin example under `ios/.symlinks/plugins/tealium/example/` demonstrates additional Tealium features (visitor service, remote commands, data layer operations).
- Replace placeholder Tealium credentials before running tests in an environment that expects real data.

If you'd like, I can also add a small script or Makefile with common commands for `flutter pub get`, `pod install`, and `flutter run` for convenience.
