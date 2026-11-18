extends Node3D

const FlowerScript = preload("res://scripts/flower.gd")
const BasketScript = preload("res://scripts/basket.gd")
const PlayerScript = preload("res://scripts/player.gd")

const ROOM_WIDTH := 24.0
const ROOM_DEPTH := 22.0
const UPPER_FLOOR_Y := 4.2

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
	ramp.position = Vector3(0, 2.0, 4.05)
	ramp.rotation.x = atan(UPPER_FLOOR_Y / 10.2)
	var shape := BoxShape3D.new()
	shape.size = Vector3(3.0, 0.24, 10.8)
	var collision := CollisionShape3D.new()
	collision.shape = shape
	ramp.add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = shape.size
	visual.mesh = mesh
	visual.material_override = _material(Color("#bc8b62"))
	ramp.add_child(visual)
	for side in [-1.0, 1.0]:
		var rail_shape := BoxShape3D.new()
		rail_shape.size = Vector3(0.14, 0.84, 10.8)
		var rail_collision := CollisionShape3D.new()
		rail_collision.shape = rail_shape
		rail_collision.position = Vector3(side * 1.42, 0.52, 0)
		ramp.add_child(rail_collision)
		var rail_visual := MeshInstance3D.new()
		var rail_mesh := BoxMesh.new()
		rail_mesh.size = rail_shape.size
		rail_visual.mesh = rail_mesh
		rail_visual.position = rail_collision.position
		rail_visual.material_override = _material(Color("#9a694a"))
		ramp.add_child(rail_visual)
	add_child(ramp)

func _add_wall_cabinets(floor_y: float) -> void:
	var base_y := floor_y + 2.15
	var back_z := -ROOM_DEPTH / 2.0 + 0.48
	_add_box("WallCabinetBackBody", Vector3(4.6, 0.92, 0.72), Vector3(0, base_y, back_z), Color("#9a694a"), false)
	for index in 4:
		var x := -1.68 + float(index) * 1.12
		_add_box("WallCabinetBackDoor", Vector3(1.02, 0.78, 0.06), Vector3(x, base_y, back_z + 0.39), Color("#e4d5bd"), false)
		_add_box("WallCabinetBackKnob", Vector3(0.055, 0.055, 0.055), Vector3(x + 0.34, base_y, back_z + 0.44), Color("#d4a65e"), false)
	for side in [-1.0, 1.0]:
		var side_x := side * (ROOM_WIDTH / 2.0 - 0.48)
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
	var types: Array[String] = ["rose", "tulip", "daisy", "sunflower", "lavender", "peony", "orchid", "lily", "cosmos"]
	var basket_spots := {
		"rose": Vector3(-9.5, 0, -7.6),
		"tulip": Vector3(9.5, 0, -7.6),
		"daisy": Vector3(-9.5, 0, -1.8),
		"sunflower": Vector3(9.5, 0, -1.8),
		"lavender": Vector3(-9.5, 0, 4.8),
		"peony": Vector3(9.5, 0, 4.8),
		"orchid": Vector3(-9.7, UPPER_FLOOR_Y, -7.8),
		"lily": Vector3(9.7, UPPER_FLOOR_Y, -7.8),
		"cosmos": Vector3(0.0, UPPER_FLOOR_Y, -2.4),
	}
	for flower_type in types:
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		var basket := BasketScript.new()
		basket.setup(flower_type, tint)
		basket.position = basket_spots[flower_type]
		add_child(basket)
	var lower_positions: Array[Vector3] = []
	for row in 24:
		for column in 27:
			var x := -9.5 + float(column) * (19.0 / 26.0)
			var z := -9.5 + float(row) * (19.0 / 23.0)
			if x > -1.75 and x < 1.75 and z > -1.4:
				continue
			if absf(x) < 2.2 and z < -7.0:
				continue
			if absf(absf(x) - 8.5) < 0.7 and absf(z + 1.35) < 0.7:
				continue
			if absf(absf(x) - 3.8) < 1.5 and absf(z + 1.0) < 1.0:
				continue
			var blocked_by_basket := false
			for basket_value in basket_spots.values():
				var basket_position: Vector3 = basket_value
				if is_zero_approx(basket_position.y) and Vector2(x, z).distance_to(Vector2(basket_position.x, basket_position.z)) < 1.05:
					blocked_by_basket = true
					break
			if blocked_by_basket:
				continue
			lower_positions.append(Vector3(x, 0, z))
	var upper_positions: Array[Vector3] = []
	for row in 20:
		for column in 30:
			var x := -9.0 + float(column) * (18.0 / 29.0)
			var z := -10.0 + float(row) * (8.4 / 19.0)
			if absf(x) < 1.75 and z > -3.0:
				continue
			var blocked_by_basket := false
			for basket_value in basket_spots.values():
				var basket_position: Vector3 = basket_value
				if is_equal_approx(basket_position.y, UPPER_FLOOR_Y) and Vector2(x, z).distance_to(Vector2(basket_position.x, basket_position.z)) < 1.1:
					blocked_by_basket = true
					break
			if blocked_by_basket:
				continue
			upper_positions.append(Vector3(x, UPPER_FLOOR_Y, z))
	var type_counts: Dictionary = {}
	var pickup_nodes_by_type: Dictionary = {}
	for flower_type in types:
		type_counts[flower_type] = 0
	var total_flowers: int = GameState.TOTAL_FLOWERS
	var flowers_per_floor := floori(float(total_flowers) / 2.0)
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
		var slot := floori(float(floor_flowers_before) * float(candidates.size()) / float(flowers_per_floor))
		var flower_position: Vector3 = candidates[slot]
		var flower := FlowerScript.new()
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		flower.setup(flower_id, flower_type, tint)
		var jitter_strength := 0.14 if floor_index == 0 else 0.08
		var jitter_phase := float(flower_index) * 1.618
		flower.position = flower_position + Vector3(cos(jitter_phase) * jitter_strength, 0, sin(jitter_phase) * jitter_strength)
		add_child(flower)
		if not pickup_nodes_by_type.has(flower_type):
			pickup_nodes_by_type[flower_type] = []
		pickup_nodes_by_type[flower_type].append(flower)
	var stem_positions: Array[Vector3] = []
	for flower_type in types:
		for flower in pickup_nodes_by_type[flower_type]:
			stem_positions.append(flower.position)
	var stem_batch := _create_flower_batch(
		FlowerScript.build_stem_mesh(), stem_positions, _material(Color("#5c9567")), "SharedFlowerStems"
	)
	var stem_index := 0
	for flower_type in types:
		var flower_nodes: Array = pickup_nodes_by_type[flower_type]
		var bloom_positions: Array[Vector3] = []
		for flower in flower_nodes:
			bloom_positions.append(flower.position)
		var bloom_batch := _create_flower_batch(
			FlowerScript.build_bloom_mesh(flower_type),
			bloom_positions,
			_material(GameState.FLOWER_TYPES[flower_type].color),
			"BloomBatch_" + flower_type
		)
		for index in flower_nodes.size():
			flower_nodes[index].set_visual_batches(stem_batch, stem_index, bloom_batch, index)
			stem_index += 1

func _create_flower_batch(mesh: Mesh, positions: Array[Vector3], material: Material, batch_name: String) -> MultiMeshInstance3D:
	var batch := MultiMeshInstance3D.new()
	batch.name = batch_name
	var multimesh := MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = mesh
	multimesh.instance_count = positions.size()
	for index in positions.size():
		multimesh.set_instance_transform(index, Transform3D(Basis.IDENTITY, positions[index]))
	batch.multimesh = multimesh
	batch.material_override = material
	add_child(batch)
	return batch

func _build_player() -> void:
	var player := PlayerScript.new()
	player.position = Vector3(0, 0, 9.0)
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
