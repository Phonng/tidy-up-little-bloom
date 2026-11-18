# Little Bloom

Godot 4 / GDScript Android first-person flower-sorting prototype. The project is offline-first and uses procedural placeholder meshes so the first playable loop does not depend on downloaded art.

## Open the project

1. Install the current stable Godot editor. The current project baseline is Godot 4.7.2; see `ANDROID_RELEASE_GUIDE.md` for Android SDK and Play target API details.
2. Open this folder or `project.godot` in Godot.
3. Press Run. The title screen offers New Game, Continue, and Settings. Desktop controls: WASD/arrows to move, click to capture the mouse, mouse to look, E to interact, Esc to release the mouse.
4. Android uses landscape touch controls: left side to move, drag on the right to look, and the lower-right button to pick up/place.

## Current prototype

- Small blockout flower shop, first-person movement and collision.
- Nine flower types with 600 flowers total (66–67 of each), nine sorting baskets, wall cabinets, and a two-floor shop connected by a walkable ramp; five-item carry limit.
- Context interaction, progress HUD, local save and resume.
- The room, flower silhouettes, baskets and display props use original procedural meshes. Original synthesized SFX and shop ambience are included; no third-party assets are bundled.
- Main menu includes a Godot Engine license entry under Credits & licenses.

## Next steps

Start with `PRODUCT_SPEC.md` for the product scope and requirements. Use `ROADMAP_CHECKLIST.md` to track work part by part, and `ke-hoach-little-bloom-android.md` for the 16–20 week implementation plan. Replace placeholder art only after the Android touch loop feels comfortable.

## Android release

See `ANDROID_RELEASE_GUIDE.md` for the Android setup. The tracked Play export preset uses application ID `com.phonng.littlebloom`; keep release credentials in Godot's local `.godot/export_credentials.cfg`, never in Git.

Store listing copy and graphic files are in `PLAY_STORE_DRAFT.md` and `store/`. `PRIVACY_POLICY.md` is shown from the game menu; add a monitored support email and host the final policy at a public HTTPS URL before publishing.

## License notes

The Godot Engine is MIT-licensed; its notice is included in the in-game Credits & licenses screen. See `ASSET_LEDGER.md` for project-created artwork and synthesized audio.
