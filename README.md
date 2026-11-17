# Little Bloom

Godot 4 / GDScript Android first-person flower-sorting prototype. The project is offline-first and uses procedural placeholder meshes so the first playable loop does not depend on downloaded art.

## Open the project

1. Install a Godot 4 stable editor.
2. Open this folder or `project.godot` in Godot.
3. Press Run. The title screen offers New Game, Continue, and Settings. Desktop controls: WASD/arrows to move, click to capture the mouse, mouse to look, E to interact, Esc to release the mouse.
4. Android uses landscape touch controls: left side to move, drag on the right to look, and the lower-right button to pick up/place.

## Current prototype

- Small blockout flower shop, first-person movement and collision.
- Three flower types, three baskets, 30 flowers, five-item carry limit.
- Context interaction, progress HUD, local save and resume.
- The room, flower silhouettes and baskets use original procedural low-poly meshes; no third-party assets are included yet.

## Next steps

Start with `PRODUCT_SPEC.md` for the product scope and requirements. Use `ROADMAP_CHECKLIST.md` to track work part by part, and `ke-hoach-little-bloom-android.md` for the 16–20 week implementation plan. Replace placeholder art only after the Android touch loop feels comfortable.

## License notes

The Godot Engine is MIT-licensed. Add the required engine notice to an in-game credits/licenses screen before distributing a build. No third-party art or audio is currently bundled.
