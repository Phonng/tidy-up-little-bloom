# Android build and release guide

Last checked: 17 November 2026. This file records the project setup decisions; release requirements can change, so re-check the linked official pages when making a store build.

## Current project baseline

- **Godot:** 4.7.2 stable is the latest stable release listed on the official archive on the date above. Godot 4.8 is still beta, so keep this project on a stable editor until 4.8 has a stable release and the project has been migrated deliberately. [Official Godot release archive](https://godotengine.org/download/archive/)
- **Renderer:** Compatibility / OpenGL, selected for broad mobile reach. Confirm visual quality and frame time on target devices before release.
- **Orientation:** landscape.
- **Project icon:** original SVG at `assets/ui/little_bloom_icon.svg`. The Android export preset still needs launcher icon images in the resolutions requested by Godot.
- **Application ID:** not set yet. Choose a reverse-DNS identifier you control before the first Play upload; changing it later creates a different Android app identity.

## Android SDK and JDK

Godot's stable Android export guide recommends OpenJDK 17 and documents the Android SDK setup and export templates. Install the Android SDK through Android Studio or the official Android command-line tools, then configure the Java SDK Path and Android SDK Path in Godot Editor Settings. The SDK path must contain `platform-tools/adb`.

Official references:

- [Godot 4.7 Android export](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html)
- [Godot 4.7 Gradle build setup](https://docs.godotengine.org/en/4.7/tutorials/export/android_gradle_build.html)

## Google Play target API requirement

As of 31 August 2026, new apps and app updates submitted to Google Play must target Android 16 (API level 36) or higher. Godot 4.7's stable export guide still lists the earlier SDK 35 package set, so do not assume the default preset satisfies the current Play requirement. Install the SDK platform/build tools needed for API 36, set the Android export preset's Gradle target SDK to `36`, and verify the exported manifest before upload. If the 4.7.2 template does not produce a valid API 36 package, wait for a supported stable Godot release or follow the current official export docs; do not ship a beta editor build as the release baseline.

- [Google Play target API requirement](https://developer.android.com/google/play/requirements/target-sdk)
- [Godot 4.7 Android export options](https://docs.godotengine.org/en/4.7/classes/class_editorexportplatformandroid.html)
- [Godot latest Android export instructions](https://docs.godotengine.org/en/latest/tutorials/export/exporting_for_android.html)

## Export checklist

- [ ] Install the matching export templates for the selected Godot editor version.
- [ ] Configure JDK 17 and Android SDK paths in Godot Editor Settings.
- [ ] Add an Android export preset and set a permanent reverse-DNS application ID.
- [ ] Enable Gradle build and export format AAB for Google Play.
- [ ] Set target SDK 36 or higher; confirm the final manifest reports that target.
- [ ] Add main and adaptive launcher icons at the sizes requested by the editor.
- [ ] Enable only the ARM architectures needed for the supported device range; keep ARM64.
- [ ] Generate a release keystore outside the repository and keep its passwords private.
- [ ] Export a signed release AAB with debug signing disabled.
- [ ] Install the release candidate through a Play testing track and check launch, resume, save and touch controls.

## Secrets and version control

`export_presets.cfg` remains ignored because it can contain signing paths and passwords. Never commit the release keystore, signing passwords, or private keys. Keep the keystore backed up securely outside this repository. Increase the Android version code for every Play release.

## Performance work

Do not claim an FPS target until the build has been measured on named Android devices. Measure a 15-minute session, initial load time, memory use, and thermal behavior; keep the observed device/version results in the release notes. Begin with shadows and realtime lights disabled, then add only effects that remain within the device budget.
