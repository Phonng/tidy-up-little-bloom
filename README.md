# Little Bloom

Godot 4 / GDScript Android first-person flower-sorting prototype. The project is offline-first and uses procedural placeholder meshes so the first playable loop does not depend on downloaded art.

## Open the project

1. Install a Godot 4 stable editor.
2. Open this folder or `project.godot` in Godot.
3. Press Run. Desktop controls: WASD/arrows to move, click to capture the mouse, mouse to look, E to interact, Esc to release the mouse.
4. Android uses landscape touch controls: left side to move, drag on the right to look, and the lower-right button to pick up/place.

## Current prototype

- Small blockout flower shop, first-person movement and collision.
- Three flower types, three baskets, 30 flowers, five-item carry limit.
- Context interaction, progress HUD, local save and resume.
- All visual objects are procedural placeholders; no third-party assets are included.

## Next steps

See `ke-hoach-little-bloom-android.md` for the full GDD, 16–20 week plan, asset licensing checklist, release schedule and acceptance criteria. Replace placeholder art only after the Android touch loop feels comfortable.

## License notes

The Godot Engine is MIT-licensed. Add the required engine notice to an in-game credits/licenses screen before distributing a build. No third-party art or audio is currently bundled.
