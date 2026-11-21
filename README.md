# Little Bloom

Godot 4 / GDScript Android first-person flower-sorting prototype. The project is offline-first and uses procedural placeholder meshes so the first playable loop does not depend on downloaded art.

## Open the project

1. Install the current stable Godot editor. The current project baseline is Godot 4.7.2; see `ANDROID_RELEASE_GUIDE.md` for Android SDK and Play target API details.
2. Open this folder or `project.godot` in Godot.
3. Press Run. Choose **Demo · 90 bông** or **Thử tải · 504 bông (save cũ)**, then select Chơi mới (New Game) or Tiếp tục (Continue). Desktop controls: WASD/arrows to move, click to capture the mouse, mouse to look, E to interact, Esc to release the mouse.
4. Android uses landscape touch controls: left side to move, drag on the right to look, and the lower-right button to pick up/place.

## Current prototype

- Small blockout flower shop, first-person movement and collision.
- Nine flower types, nine baskets and a five-item carry limit across two floors. Demo uses 10 flowers per type and the stress test uses 56.
- Context interaction, progress HUD, local save and resume.
- The room, flower silhouettes, baskets and display props use original procedural meshes. Original synthesized SFX and shop ambience are included; no third-party assets are bundled.
- Main menu includes a Godot Engine license entry under Credits & licenses.

## Demo scope agreed on 19 November 2026

The 90-flower demo is the default. Existing progress is available by choosing **Thử tải · 504 bông (save cũ)** and **Tiếp tục**. Each mode has its own save. New Game, reset and replay apply to the selected mode. The demo opens beside ten roses and their basket, with step-by-step guidance during play. Existing demo progress carries into the new layout. The 2–3 minute target is pending first-time player testing.

See `DEMO_PLAN.md` for the opening layout, save compatibility and acceptance criteria. The updated Claude plan is preserved in [`docs/reference/CLAUDE_PLAN_V2_2026-11-19.txt`](docs/reference/CLAUDE_PLAN_V2_2026-11-19.txt); its task IDs are mapped to the demo in `DEMO_PLAN.md` (21 November update), while the full-release proposals remain outside the current demo scope. First-person hands have been removed; the staircase has 20 visible steps with a smooth collision surface, and D0 now keeps grounded movement through the transition and spawns the player on flat ground. The [staircase probe](docs/STAIRCASE_CHECK.md) passes 140 simulated round trips; A windowed Mac run rendered both ends of the staircase and reached all nine baskets with scripted input. Manual controls and Android traversal still need verification.

## Next steps

Read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the current scene structure, all ten scripts, input, flower data and save flow. It documents source inspection, not runtime or Android test results. Track reported problems, reproduction steps and closure criteria in [`docs/KNOWN_ISSUES.md`](docs/KNOWN_ISSUES.md); staircase issue LB-001 is the first gameplay priority.

Start with `PRODUCT_SPEC.md` for the product scope and requirements. Use `ROADMAP_CHECKLIST.md` to track work part by part, and `ke-hoach-little-bloom-android.md` for the older 16–20 week reference plan; the current demo priorities are in `DEMO_PLAN.md`. Replace placeholder art only after the Android touch loop feels comfortable.

## Android release

See `ANDROID_RELEASE_GUIDE.md` for the Android setup. The tracked Play export preset uses application ID `com.phonng.littlebloom`; keep release credentials in Godot's local `.godot/export_credentials.cfg`, never in Git.

Store listing copy and graphic files are in `PLAY_STORE_DRAFT.md` and `store/`. `PRIVACY_POLICY.md` is shown from the game menu; add a monitored support email and host the final policy at a public HTTPS URL before publishing.

## License notes

The Godot Engine is MIT-licensed; its notice is included in the in-game Credits & licenses screen. See `ASSET_LEDGER.md` for project-created artwork and synthesized audio.
