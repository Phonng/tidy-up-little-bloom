extends Node3D

const FlowerScript = preload("res://scripts/flower.gd")
const BasketScript = preload("res://scripts/basket.gd")
const PlayerScript = preload("res://scripts/player.gd")

const ROOM_WIDTH := 24.0
const ROOM_DEPTH := 22.0

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
	_add_window()
	_add_potted_plant(Vector3(9.8, 0, -9.0), Color("#d96b78"))
	_add_potted_plant(Vector3(-9.8, 0, -9.0), Color("#e6a34e"))
	_add_potted_plant(Vector3(9.8, 0, 9.0), Color("#9d82c4"))
	_add_potted_plant(Vector3(-9.8, 0, 9.0), Color("#edbd48"))
	_add_box("WelcomeMat", Vector3(3.2, 0.035, 1.2), Vector3(0, 0.02, 9.2), Color("#9e7064"), false)

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
	var types: Array[String] = ["rose", "tulip", "daisy", "sunflower", "lavender", "peony"]
	var basket_spots := {
		"rose": Vector3(-10.0, 0, -6.5),
		"tulip": Vector3(10.0, 0, -6.5),
		"daisy": Vector3(-10.0, 0, 0),
		"sunflower": Vector3(10.0, 0, 0),
		"lavender": Vector3(-10.0, 0, 6.5),
		"peony": Vector3(10.0, 0, 6.5),
	}
	for flower_type in types:
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		var basket := BasketScript.new()
		basket.setup(flower_type, tint)
		basket.position = basket_spots[flower_type]
		add_child(basket)
	var type_counts: Dictionary = {}
	for flower_type in types:
		type_counts[flower_type] = 0
	var zone_centers: Array[Vector2] = [
		Vector2(-6.0, -6.0), Vector2(0.0, -6.0), Vector2(6.0, -6.0),
		Vector2(-6.0, 0.0), Vector2(0.0, 0.0), Vector2(6.0, 0.0),
		Vector2(-6.0, 6.0), Vector2(0.0, 6.0), Vector2(6.0, 6.0),
	]
	var total_flowers := types.size() * GameState.TARGET_PER_TYPE
	for flower_index in total_flowers:
		var flower_type: String = types[flower_index % types.size()]
		var type_number: int = type_counts[flower_type] + 1
		type_counts[flower_type] = type_number
		var flower_id := "%s_%02d" % [flower_type, type_number]
		if flower_id in GameState.placed_ids or flower_id in GameState.inventory:
			continue
		var flower := FlowerScript.new()
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		flower.setup(flower_id, flower_type, tint)
		var zone := flower_index % zone_centers.size()
		var spot := floori(float(flower_index) / float(zone_centers.size()))
		var angle := TAU * float(spot) / 7.0
		var radius := 1.25 + float(spot % 3) * 0.18
		var center: Vector2 = zone_centers[zone]
		flower.position = Vector3(center.x + cos(angle) * radius, 0, center.y + sin(angle) * radius)
		add_child(flower)

func _build_player() -> void:
	var player := PlayerScript.new()
	player.position = Vector3(0, 0, 9.0)
	add_child(player)

func _add_window() -> void:
	var center := Vector3(6.2, 2.0, -10.78)
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
