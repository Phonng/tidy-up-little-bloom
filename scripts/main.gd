extends Node3D

const BasketScript = preload("res://scripts/basket.gd")
const FlowerFieldScript = preload("res://scripts/flower_field.gd")
const PlayerScript = preload("res://scripts/player.gd")

const ROOM_WIDTH := 24.0
const ROOM_DEPTH := 22.0
const UPPER_FLOOR_Y := LevelConfig.UPPER_FLOOR_Y
const RAMP_BOTTOM_Z := 9.0
const RAMP_TOP_Z := -0.8
const RAMP_RUN := RAMP_BOTTOM_Z - RAMP_TOP_Z
const RAMP_WIDTH := 4.0
const RAMP_THICKNESS := 0.08
const STAIR_STEP_COUNT := 20
const PLAYER_SPAWN := Vector3(0.0, 0.05, 9.8)

func _ready() -> void:
	_build_lighting()
	_build_room()
	_build_shop_props()
	_build_level_objects()
	_build_player()

func _build_lighting() -> void:
	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#eadfcf")
	env.ambient_light_energy = 0.75
	environment.environment = env
	add_child(environment)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -28, 0)
	sun.light_energy = 1.0
	sun.shadow_enabled = false
	add_child(sun)

func _build_room() -> void:
	var half_width := ROOM_WIDTH / 2.0
	var half_depth := ROOM_DEPTH / 2.0
	_add_box("Floor", Vector3(ROOM_WIDTH, 0.2, ROOM_DEPTH), Vector3(0, -0.1, 0), Color("#d9c6a8"), true)
	_add_box("BackWall", Vector3(ROOM_WIDTH, 3.2, 0.2), Vector3(0, 1.5, -half_depth), Color("#efe6d6"), true)
	_add_box("LeftWall", Vector3(0.2, 3.2, ROOM_DEPTH), Vector3(-half_width, 1.5, 0), Color("#e8ddca"), true)
	_add_box("RightWall", Vector3(0.2, 3.2, ROOM_DEPTH), Vector3(half_width, 1.5, 0), Color("#e8ddca"), true)
	_add_box("FrontWall", Vector3(ROOM_WIDTH, 3.2, 0.2), Vector3(0, 1.5, half_depth), Color("#efe6d6"), true)
	_add_box("Counter", Vector3(3.6, 0.9, 0.9), Vector3(0, 0.45, -8.1), Color("#a87552"), true)
	_add_box("Shelf", Vector3(4.2, 1.8, 0.35), Vector3(-7.0, 0.9, -9.25), Color("#9a694a"), true)
	_add_box("ShelfBoard1", Vector3(4.2, 0.12, 0.5), Vector3(-7.0, 0.7, -9.0), Color("#bc8b62"), true)
	_add_box("ShelfBoard2", Vector3(4.2, 0.12, 0.5), Vector3(-7.0, 1.35, -9.0), Color("#bc8b62"), true)
	_add_box("DisplayIslandLeft", Vector3(2.4, 0.72, 1.0), Vector3(-3.8, 0.36, -1.0), Color("#b98558"), true)
	_add_box("DisplayIslandRight", Vector3(2.4, 0.72, 1.0), Vector3(3.8, 0.36, -1.0), Color("#b98558"), true)
	_add_box("UpperFloor", Vector3(ROOM_WIDTH, 0.2, 10.4), Vector3(0, UPPER_FLOOR_Y - 0.1, -6.0), Color("#d5bea0"), true)
	_add_box("UpperBackWall", Vector3(ROOM_WIDTH, 3.2, 0.2), Vector3(0, UPPER_FLOOR_Y + 1.5, -half_depth), Color("#efe6d6"), true)
	_add_box("UpperLeftWall", Vector3(0.2, 3.2, 10.4), Vector3(-half_width, UPPER_FLOOR_Y + 1.5, -6.0), Color("#e8ddca"), true)
	_add_box("UpperRightWall", Vector3(0.2, 3.2, 10.4), Vector3(half_width, UPPER_FLOOR_Y + 1.5, -6.0), Color("#e8ddca"), true)
	_add_box("UpperFrontRailLeft", Vector3(9.3, 0.9, 0.16), Vector3(-7.35, UPPER_FLOOR_Y + 0.45, -0.78), Color("#bc8b62"), true)
	_add_box("UpperFrontRailRight", Vector3(9.3, 0.9, 0.16), Vector3(7.35, UPPER_FLOOR_Y + 0.45, -0.78), Color("#bc8b62"), true)
	for side in [-1.0, 1.0]:
		for depth in [-10.6, -1.35]:
			_add_box("UpperFloorSupport", Vector3(0.32, UPPER_FLOOR_Y, 0.32), Vector3(side * 8.5, UPPER_FLOOR_Y / 2.0, depth), Color("#9a694a"), true)
	_add_ramp()
	_add_wall_cabinets(0.0)
	_add_wall_cabinets(UPPER_FLOOR_Y)
	_add_window_at(2.0)
	_add_window_at(UPPER_FLOOR_Y + 2.0)
	_add_potted_plant(Vector3(9.8, 0, -9.0), Color("#d96b78"))
	_add_potted_plant(Vector3(-9.8, 0, -9.0), Color("#e6a34e"))
	_add_potted_plant(Vector3(9.8, 0, 9.0), Color("#9d82c4"))
	_add_potted_plant(Vector3(-9.8, 0, 9.0), Color("#edbd48"))
	_add_potted_plant(Vector3(9.8, UPPER_FLOOR_Y, -9.0), Color("#b266aa"))
	_add_potted_plant(Vector3(-9.8, UPPER_FLOOR_Y, -9.0), Color("#f2eee0"))
	_add_box("WelcomeMat", Vector3(3.2, 0.035, 1.2), Vector3(0, 0.02, 9.2), Color("#9e7064"), false)

func _add_ramp() -> void:
	var ramp := StaticBody3D.new()
	ramp.name = "StairRamp"
	var ramp_angle := atan(UPPER_FLOOR_Y / RAMP_RUN)
	var ramp_length := sqrt(RAMP_RUN * RAMP_RUN + UPPER_FLOOR_Y * UPPER_FLOOR_Y)
	var ramp_center_z := (RAMP_BOTTOM_Z + RAMP_TOP_Z) / 2.0
	var ramp_center_y := UPPER_FLOOR_Y / 2.0 - cos(ramp_angle) * RAMP_THICKNESS / 2.0
	ramp.position = Vector3(0, ramp_center_y, ramp_center_z)
	ramp.rotation.x = ramp_angle
	var shape := BoxShape3D.new()
	shape.size = Vector3(RAMP_WIDTH, RAMP_THICKNESS, ramp_length)
	var collision := CollisionShape3D.new()
	collision.shape = shape
	ramp.add_child(collision)
	for side in [-1.0, 1.0]:
		var rail_shape := BoxShape3D.new()
		rail_shape.size = Vector3(0.14, 0.84, ramp_length)
		var rail_collision := CollisionShape3D.new()
		rail_collision.shape = rail_shape
		rail_collision.position = Vector3(side * (RAMP_WIDTH / 2.0 - 0.12), 0.48, 0)
		ramp.add_child(rail_collision)
		var rail_visual := MeshInstance3D.new()
		var rail_mesh := BoxMesh.new()
		rail_mesh.size = rail_shape.size
		rail_visual.mesh = rail_mesh
		rail_visual.position = rail_collision.position
		rail_visual.material_override = _material(Color("#9a694a"))
		ramp.add_child(rail_visual)
	add_child(ramp)
	_add_stair_steps()

func _add_stair_steps() -> void:
	var step_run := RAMP_RUN / float(STAIR_STEP_COUNT)
	var tread_depth := step_run + 0.08
	var tread_thickness := 0.14
	var tread_material := _material(Color("#bc8b62"))
	var riser_material := _material(Color("#9a694a"))
	var previous_top := 0.0
	for step_index in STAIR_STEP_COUNT:
		var step_center_z := RAMP_BOTTOM_Z - (float(step_index) + 0.5) * step_run
		var step_top_y := UPPER_FLOOR_Y * (RAMP_BOTTOM_Z - step_center_z) / RAMP_RUN
		var tread := MeshInstance3D.new()
		tread.name = "StairTread_%02d" % step_index
		var tread_mesh := BoxMesh.new()
		tread_mesh.size = Vector3(RAMP_WIDTH - 0.28, tread_thickness, tread_depth)
		tread.mesh = tread_mesh
		tread.position = Vector3(0, step_top_y - tread_thickness / 2.0, step_center_z)
		tread.material_override = tread_material
		add_child(tread)

		var boundary_z := RAMP_BOTTOM_Z - float(step_index + 1) * step_run
		var riser_top_y := UPPER_FLOOR_Y * (RAMP_BOTTOM_Z - boundary_z) / RAMP_RUN
		var riser_height := riser_top_y - previous_top
		var riser := MeshInstance3D.new()
		riser.name = "StairRiser_%02d" % step_index
		var riser_mesh := BoxMesh.new()
		riser_mesh.size = Vector3(RAMP_WIDTH - 0.30, riser_height, 0.07)
		riser.mesh = riser_mesh
		riser.position = Vector3(0, previous_top + riser_height / 2.0, boundary_z)
		riser.material_override = riser_material
		add_child(riser)
		previous_top = riser_top_y

func _add_wall_cabinets(floor_y: float) -> void:
	var base_y := floor_y + 2.15
	var back_z := -ROOM_DEPTH / 2.0 + 0.48
	_add_box("WallCabinetBackBody", Vector3(4.6, 0.92, 0.72), Vector3(0, base_y, back_z), Color("#9a694a"), false)
	for index in 4:
		var x := -1.68 + float(index) * 1.12
		_add_box("WallCabinetBackDoor", Vector3(1.02, 0.78, 0.06), Vector3(x, base_y, back_z + 0.39), Color("#e4d5bd"), false)
		_add_box("WallCabinetBackKnob", Vector3(0.055, 0.055, 0.055), Vector3(x + 0.34, base_y, back_z + 0.44), Color("#d4a65e"), false)
	for side in [-1.0, 1.0]:
		var side_x: float = float(side) * (ROOM_WIDTH / 2.0 - 0.48)
		_add_box("WallCabinetSideBody", Vector3(0.72, 0.92, 4.2), Vector3(side_x, base_y, -6.0), Color("#9a694a"), false)
		for index in 3:
			var z := -7.4 + float(index) * 1.4
			_add_box("WallCabinetSideDoor", Vector3(0.06, 0.78, 1.28), Vector3(side_x - side * 0.39, base_y, z), Color("#e4d5bd"), false)

func _build_shop_props() -> void:
	_add_pendant_lamp()
	_add_counter_gifts()
	_add_shelf_vases()

func _add_pendant_lamp() -> void:
	var cord := MeshInstance3D.new()
	var cord_mesh := CylinderMesh.new()
	cord_mesh.top_radius = 0.018
	cord_mesh.bottom_radius = 0.018
	cord_mesh.height = 0.52
	cord.mesh = cord_mesh
	cord.position = Vector3(0, 2.91, -5.0)
	cord.material_override = _material(Color("#775b48"))
	add_child(cord)
	var shade := MeshInstance3D.new()
	var shade_mesh := CylinderMesh.new()
	shade_mesh.top_radius = 0.16
	shade_mesh.bottom_radius = 0.34
	shade_mesh.height = 0.22
	shade.mesh = shade_mesh
	shade.position = Vector3(0, 2.54, -5.0)
	shade.material_override = _material(Color("#e6b76b"))
	add_child(shade)
	var bulb := MeshInstance3D.new()
	var bulb_mesh := SphereMesh.new()
	bulb_mesh.radius = 0.095
	bulb_mesh.height = 0.19
	bulb.mesh = bulb_mesh
	bulb.position = Vector3(0, 2.39, -5.0)
	var bulb_material := _material(Color("#ffe5a8"))
	bulb_material.emission_enabled = true
	bulb_material.emission = Color("#f8d99a")
	bulb_material.emission_energy_multiplier = 0.35
	bulb.material_override = bulb_material
	add_child(bulb)

func _add_counter_gifts() -> void:
	_add_box("GiftBoxSage", Vector3(0.42, 0.3, 0.36), Vector3(-0.88, 1.04, -8.08), Color("#8da78a"), false)
	_add_box("GiftRibbonSage", Vector3(0.09, 0.31, 0.37), Vector3(-0.88, 1.04, -8.08), Color("#f0ddbd"), false)
	_add_box("GiftBoxRose", Vector3(0.34, 0.24, 0.32), Vector3(0.92, 1.01, -8.1), Color("#d9868b"), false)
	_add_box("GiftRibbonRose", Vector3(0.07, 0.25, 0.33), Vector3(0.92, 1.01, -8.1), Color("#f4e5ca"), false)
	_add_box("TissuePaper", Vector3(0.6, 0.025, 0.38), Vector3(0.0, 0.92, -8.08), Color("#e7cfae"), false)

func _add_shelf_vases() -> void:
	_add_decorative_vase(Vector3(-8.2, 1.42, -9.05), Color("#d96b78"), Color("#719b73"))
	_add_decorative_vase(Vector3(-7.0, 1.42, -9.05), Color("#e6a34e"), Color("#84a87d"))
	_add_decorative_vase(Vector3(-5.8, 1.42, -9.05), Color("#f2d976"), Color("#739b70"))

func _add_decorative_vase(at: Vector3, bloom_color: Color, leaf_color: Color) -> void:
	var vase := MeshInstance3D.new()
	var vase_mesh := CylinderMesh.new()
	vase_mesh.top_radius = 0.17
	vase_mesh.bottom_radius = 0.12
	vase_mesh.height = 0.34
	vase.mesh = vase_mesh
	vase.position = at + Vector3(0, 0.17, 0)
	vase.material_override = _material(Color("#d9c1a4"))
	add_child(vase)
	var stem := MeshInstance3D.new()
	var stem_mesh := CylinderMesh.new()
	stem_mesh.top_radius = 0.012
	stem_mesh.bottom_radius = 0.018
	stem_mesh.height = 0.46
	stem.mesh = stem_mesh
	stem.position = at + Vector3(0, 0.55, 0)
	stem.material_override = _material(Color("#5f8b68"))
	add_child(stem)
	var leaf := MeshInstance3D.new()
	var leaf_mesh := SphereMesh.new()
	leaf_mesh.radial_segments = 8
	leaf_mesh.rings = 4
	leaf.mesh = leaf_mesh
	leaf.scale = Vector3(0.16, 0.045, 0.075)
	leaf.position = at + Vector3(0.09, 0.54, 0)
	leaf.material_override = _material(leaf_color)
	add_child(leaf)
	var bloom := MeshInstance3D.new()
	var bloom_mesh := SphereMesh.new()
	bloom_mesh.radial_segments = 8
	bloom_mesh.rings = 4
	bloom.mesh = bloom_mesh
	bloom.scale = Vector3(0.12, 0.13, 0.12)
	bloom.position = at + Vector3(0, 0.84, 0)
	bloom.material_override = _material(bloom_color)
	add_child(bloom)

func _build_level_objects() -> void:
	var profile := GameState.level_profile()
	var basket_spots := LevelConfig.BASKET_SPOTS
	var types := basket_spots.keys()
	var rng := RandomNumberGenerator.new()
	rng.seed = int(profile.seed)
	for flower_type in types:
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		var basket := BasketScript.new()
		basket.setup(flower_type, tint)
		basket.position = basket_spots[flower_type]
		add_child(basket)
	var total_flowers := GameState.total_flowers()
	var flowers_per_floor := floori(float(total_flowers) / 2.0)
	var cabinet_slots: Array = profile.cabinet_slots
	var cabinet_flowers_per_floor := cabinet_slots.size()
	var floor_flowers_per_floor := flowers_per_floor - cabinet_flowers_per_floor
	var lower_positions := _generate_random_floor_positions(
		0.0,
		floor_flowers_per_floor,
		rng,
		basket_spots
	)
	var upper_positions := _generate_random_floor_positions(
		UPPER_FLOOR_Y,
		floor_flowers_per_floor,
		rng,
		basket_spots
	)
	var lower_cabinet_positions := _cabinet_flower_positions(0.0)
	var upper_cabinet_positions := _cabinet_flower_positions(UPPER_FLOOR_Y)
	for slot in cabinet_slots:
		lower_positions.append(lower_cabinet_positions[slot])
		upper_positions.append(upper_cabinet_positions[slot])
	_shuffle_positions(lower_positions, rng)
	_shuffle_positions(upper_positions, rng)
	var type_counts: Dictionary = {}
	var flowers_by_type: Dictionary = {}
	for flower_type in types:
		type_counts[flower_type] = 0
		flowers_by_type[flower_type] = []
	for flower_index in total_flowers:
		var flower_type: String = types[flower_index % types.size()]
		var type_number: int = type_counts[flower_type] + 1
		type_counts[flower_type] = type_number
		var flower_id := "%s_%02d" % [flower_type, type_number]
		if flower_id in GameState.placed_ids or flower_id in GameState.inventory:
			continue
		var floor_index := 0 if flower_index < flowers_per_floor else 1
		var floor_flowers_before := flower_index if floor_index == 0 else flower_index - flowers_per_floor
		var candidates: Array[Vector3] = lower_positions if floor_index == 0 else upper_positions
		if candidates.size() < flowers_per_floor:
			push_error("Not enough flower positions on floor %d" % floor_index)
			return
		var flower_spawn_position: Vector3 = candidates[floor_flowers_before]
		flowers_by_type[flower_type].append({"id": flower_id, "position": flower_spawn_position})
	var flower_field := FlowerFieldScript.new()
	flower_field.name = "FlowerField"
	flower_field.initialize(flowers_by_type)
	add_child(flower_field)

func _generate_random_floor_positions(
	floor_y: float,
	requested_count: int,
	rng: RandomNumberGenerator,
	basket_spots: Dictionary
) -> Array[Vector3]:
	var positions: Array[Vector3] = []
	var attempts := 0
	var max_attempts := requested_count * 80
	var minimum_spacing := 0.58 if is_zero_approx(floor_y) else 0.52
	while positions.size() < requested_count and attempts < max_attempts:
		attempts += 1
		var candidate := Vector3(
			rng.randf_range(-10.2, 10.2),
			floor_y,
			rng.randf_range(-9.7, 9.3) if is_zero_approx(floor_y)
			else rng.randf_range(-10.1, -1.0)
		)
		if _is_flower_position_blocked(candidate, basket_spots):
			continue
		var overlaps_existing := false
		for existing_value in positions:
			var existing_position: Vector3 = existing_value
			if Vector2(candidate.x, candidate.z).distance_squared_to(
				Vector2(existing_position.x, existing_position.z)
			) < minimum_spacing * minimum_spacing:
				overlaps_existing = true
				break
		if not overlaps_existing:
			positions.append(candidate)
	if positions.size() < requested_count:
		push_error("Could not create enough random flower positions on floor %.1f" % floor_y)
	return positions

func _is_flower_position_blocked(candidate_position: Vector3, basket_spots: Dictionary) -> bool:
	var x := candidate_position.x
	var z := candidate_position.z
	if is_zero_approx(candidate_position.y):
		if absf(x) < 2.25 and z > -1.2:
			return true
		if absf(x) < 2.25 and z > -8.9 and z < -7.25:
			return true
		if absf(x + 7.0) < 2.35 and z < -8.5:
			return true
		if absf(absf(x) - 3.8) < 1.55 and absf(z + 1.0) < 0.85:
			return true
		if Vector2(x, z).distance_to(Vector2(0, 9.0)) < 1.25:
			return true
		for plant_position in [Vector2(-9.8, -9.0), Vector2(9.8, -9.0), Vector2(-9.8, 9.0), Vector2(9.8, 9.0)]:
			if Vector2(x, z).distance_to(plant_position) < 0.62:
				return true
	else:
		if absf(x) < 1.85 and z > -3.0:
			return true
	for basket_value in basket_spots.values():
		var basket_position: Vector3 = basket_value
		if is_equal_approx(candidate_position.y, basket_position.y):
			if Vector2(x, z).distance_to(Vector2(basket_position.x, basket_position.z)) < 1.1:
				return true
	return false

func _cabinet_flower_positions(floor_y: float) -> Array[Vector3]:
	var positions: Array[Vector3] = []
	var flower_y := floor_y + 2.63
	for x in [-1.8, -1.1, -0.4, 0.4, 1.1, 1.8]:
		positions.append(Vector3(x, flower_y, -10.42))
	for side in [-1.0, 1.0]:
		for z in [-7.35, -6.0, -4.65]:
			positions.append(Vector3(float(side) * 11.35, flower_y, z))
	return positions

func _shuffle_positions(positions: Array[Vector3], rng: RandomNumberGenerator) -> void:
	for index in range(positions.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, index)
		var held_position: Vector3 = positions[index]
		positions[index] = positions[swap_index]
		positions[swap_index] = held_position

func _build_player() -> void:
	var player := PlayerScript.new()
	player.position = PLAYER_SPAWN
	add_child(player)

func _add_window_at(center_y: float) -> void:
	var center := Vector3(6.2, center_y, -10.78)
	_add_box("WindowGlass", Vector3(2.35, 1.25, 0.05), center, Color("#b9d9d4"), false)
	_add_box("WindowFrameTop", Vector3(2.55, 0.12, 0.12), center + Vector3(0, 0.69, 0.04), Color("#8a6048"), false)
	_add_box("WindowFrameBottom", Vector3(2.55, 0.12, 0.12), center + Vector3(0, -0.69, 0.04), Color("#8a6048"), false)
	_add_box("WindowFrameLeft", Vector3(0.12, 1.3, 0.12), center + Vector3(-1.25, 0, 0.04), Color("#8a6048"), false)
	_add_box("WindowFrameRight", Vector3(0.12, 1.3, 0.12), center + Vector3(1.25, 0, 0.04), Color("#8a6048"), false)
	_add_box("WindowMullion", Vector3(0.08, 1.22, 0.08), center + Vector3(0, 0, 0.08), Color("#8a6048"), false)
	_add_box("WindowCrossbar", Vector3(2.35, 0.07, 0.08), center + Vector3(0, 0, 0.08), Color("#8a6048"), false)

func _add_potted_plant(at: Vector3, flower_color: Color) -> void:
	var pot := MeshInstance3D.new()
	var pot_mesh := CylinderMesh.new()
	pot_mesh.top_radius = 0.25
	pot_mesh.bottom_radius = 0.18
	pot_mesh.height = 0.36
	pot.mesh = pot_mesh
	pot.position = at + Vector3(0, 0.18, 0)
	pot.material_override = _material(Color("#bd8062"))
	add_child(pot)
	var soil := MeshInstance3D.new()
	var soil_mesh := CylinderMesh.new()
	soil_mesh.top_radius = 0.21
	soil_mesh.bottom_radius = 0.21
	soil_mesh.height = 0.025
	soil.mesh = soil_mesh
	soil.position = at + Vector3(0, 0.37, 0)
	soil.material_override = _material(Color("#594537"))
	add_child(soil)
	var stem := MeshInstance3D.new()
	var stem_mesh := CylinderMesh.new()
	stem_mesh.top_radius = 0.025
	stem_mesh.bottom_radius = 0.04
	stem_mesh.height = 0.82
	stem.mesh = stem_mesh
	stem.position = at + Vector3(0, 0.78, 0)
	stem.material_override = _material(Color("#648b60"))
	add_child(stem)
	for index in 5:
		var angle := TAU * float(index) / 5.0
		var leaf := MeshInstance3D.new()
		var leaf_mesh := SphereMesh.new()
		leaf_mesh.radial_segments = 8
		leaf_mesh.rings = 4
		leaf.mesh = leaf_mesh
		leaf.scale = Vector3(0.25, 0.07, 0.12)
		leaf.position = at + Vector3(cos(angle) * 0.2, 0.86 + float(index % 2) * 0.16, sin(angle) * 0.2)
		leaf.rotation.y = -angle
		leaf.material_override = _material(Color("#739b70"))
		add_child(leaf)
	var bloom := MeshInstance3D.new()
	var bloom_mesh := SphereMesh.new()
	bloom_mesh.radial_segments = 8
	bloom_mesh.rings = 4
	bloom.mesh = bloom_mesh
	bloom.scale = Vector3(0.15, 0.12, 0.15)
	bloom.position = at + Vector3(0, 1.34, 0)
	bloom.material_override = _material(flower_color)
	add_child(bloom)

func _add_box(object_name: String, size: Vector3, at: Vector3, color: Color, solid: bool) -> void:
	var node: Node3D
	if solid:
		var body := StaticBody3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		var collision := CollisionShape3D.new()
		collision.shape = shape
		body.add_child(collision)
		node = body
	else:
		node = Node3D.new()
	node.name = object_name
	node.position = at
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	visual.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	visual.material_override = material
	node.add_child(visual)
	add_child(node)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material
