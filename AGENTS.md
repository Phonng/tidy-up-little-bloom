# Little Bloom development guidance

## Godot and GDScript

- Target Godot 4.7 and GDScript; keep the Android GL Compatibility renderer in mind.
- Read the affected scripts and scene files before changing their behavior.
- Check the official Godot documentation for APIs whose behavior affects rendering,
  physics, saving, or Android input.
- Use typed parameters and return values for script interfaces. Type variables when
  values cross script or scene boundaries; local inference is fine when the type is
  obvious from the expression.
- Use tabs for GDScript indentation, one statement per line, and descriptive names.
- Prefer signals or narrow methods for communication between systems. Avoid adding
  global state or hardcoded node paths when an existing reference or group can work.
- Keep view-only flower geometry separate from pickup/save state. Flower IDs remain
  the source of truth for inventory and saved progress.

## Mobile rendering and performance

- Keep repeated decorative meshes in MultiMeshes, but divide them into spatially
  compact regions because Godot culls each MultiMesh as one object.
- Keep interaction queries local to nearby spatial cells; don't scan all flowers
  every physics frame.
- Prefer simple low-polygon meshes and avoid per-flower physics bodies for flowers
  that can be selected with a ray query.
- When changing render batching or interaction indexing, preserve stable flower IDs
  and pickup/placement behavior.
- Do not add a test framework or run the game unless requested. Use available static
  inspection and whitespace checks, and clearly report when runtime verification is
  still needed.

## Relevant sources

- Community Godot coding-agent skill reviewed for its source-reading,
  documentation lookup, and typed GDScript workflow:
  https://github.com/fernforestgames/agent-skill-godot/blob/main/SKILL.md
- Godot GDScript style guide:
  https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_styleguide.html
- MultiMesh performance and culling:
  https://docs.godotengine.org/en/4.7/tutorials/performance/using_multimesh.html
- Visibility ranges and HLOD:
  https://docs.godotengine.org/en/4.7/tutorials/3d/visibility_ranges.html
- Mesh LOD behavior for MultiMeshes:
  https://docs.godotengine.org/en/4.7/tutorials/3d/mesh_lod.html
