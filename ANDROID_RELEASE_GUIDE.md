# Android build and release guide

Last checked: 18 November 2026. This file records the project setup decisions; release requirements can change, so re-check the linked official pages when making a store build.

## Current project baseline

- **Godot:** 4.7.2 stable is the latest stable release listed on the official archive on the date above. Godot 4.8 is still beta, so keep this project on a stable editor until 4.8 has a stable release and the project has been migrated deliberately. [Official Godot release archive](https://godotengine.org/download/archive/)
- **Renderer:** Compatibility / OpenGL, selected for broad mobile reach. Confirm visual quality and frame time on target devices before release.
- **Orientation:** landscape.
- **Project icon:** original SVG at `assets/ui/little_bloom_icon.svg`. The Android preset now references that 512×512 classic icon plus separate 512×512 adaptive foreground, background, and monochrome SVG layers under `assets/ui/`.
- **Application ID:** `com.phonng.littlebloom`, derived from the GitHub account name the user provided. Confirm that the ID is available in Play Console before the first upload; changing it after publishing creates a different Android app identity.
- **Export preset:** `export_presets.cfg` contains the non-secret Android Play preset: AAB, ARM64, target SDK 36, version code 1, the application ID above, and Android automatic app-data backup disabled. Godot credentials belong under `.godot/export_credentials.cfg`; the `.godot/` directory is excluded from Git.

## Android SDK and JDK

Godot's stable Android export guide recommends OpenJDK 17 and documents the Android SDK setup and export templates. Install the Android SDK through Android Studio or the official Android command-line tools, then configure the Java SDK Path and Android SDK Path in Godot Editor Settings. The SDK path must contain `platform-tools/adb`.

For this project, install the Android 36 platform and a matching 36.x build-tools package in addition to the NDK/CMake versions listed by the Godot 4.7 guide. Example SDK Manager packages (check current package names before installing):

```sh
sdkmanager "platform-tools" "platforms;android-36" "build-tools;36.1.0" "cmdline-tools;latest" "cmake;3.10.2.4988404" "ndk;28.1.13356709"
```

D4 verified a debug APK using isolated Java 17, Android Platform-Tools, Build-Tools 35.0.1 and the Godot 4.7.2 Android debug template. See [Android QA results](docs/ANDROID_QA.md). Gradle and the Play AAB are still separate setup and verification tasks.

Official references:

- [Godot 4.7 Android export](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html)
- [Godot 4.7 Gradle build setup](https://docs.godotengine.org/en/4.7/tutorials/export/android_gradle_build.html)

## Google Play target API requirement

Google Play currently requires new apps and updates to target Android 16 (API 36) or higher. Godot 4.7's stable export guide lists an Android 35 baseline, so install the API 36 platform/build tools, keep the preset target at `36`, and verify the built manifest before upload. If the 4.7.2 template cannot produce a valid API 36 package, follow the current official export docs with a supported stable Godot release; do not use a beta editor as the release baseline.

- [Google Play target API requirement](https://developer.android.com/google/play/requirements/target-sdk)
- [Godot 4.7 Android export options](https://docs.godotengine.org/en/4.7/classes/class_editorexportplatformandroid.html)
- [Godot latest Android export instructions](https://docs.godotengine.org/en/latest/tutorials/export/exporting_for_android.html)

## Export checklist

- [ ] Install the matching export templates for the selected Godot editor version.
- [ ] Configure JDK 17 and Android SDK paths in Godot Editor Settings.
- [x] Add a tracked Android Play export preset with application ID `com.phonng.littlebloom`.
- [x] Enable Gradle build and export format AAB for Google Play.
- [x] Set target SDK 36 in the preset.
- [ ] Export a build and confirm the final manifest has target SDK 36.
- [x] Add main (minimum 192×192) and adaptive (minimum 432×432) launcher icon layers; Godot generates smaller density variants.
- [x] Enable only ARM64 for the current supported device range; add ARM32 only if the device plan requires it.
- [ ] Generate a release keystore outside the repository and keep its passwords private.
- [ ] Export a signed release AAB with debug signing disabled.
- [ ] Install the release candidate through a Play testing track and check launch, resume, save and touch controls.

## Secrets and version control

Godot's export documentation says `export_presets.cfg` is safe to commit; private export credentials are stored separately in `.godot/export_credentials.cfg`. Never commit the release keystore, signing passwords, or private keys. Keep the keystore backed up securely outside this repository. Increase the Android version code for every Play release. [Godot export configuration files](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_projects.html)

Create the release key yourself after Java is installed. Use a path outside this repository and securely back up the key and passwords; losing the upload key can block future updates:

```sh
keytool -v -genkey -keystore /secure/path/outside/repo/little-bloom-release.keystore -alias little-bloom-upload -keyalg RSA -validity 10000
```

## Performance work

Do not claim an FPS target until the build has been measured on named Android devices. Measure a 15-minute session, initial load time, memory use, and thermal behavior; keep the observed device/version results in the release notes. Begin with shadows and realtime lights disabled, then add only effects that remain within the device budget.
