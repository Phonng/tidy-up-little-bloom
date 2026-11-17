extends Node3D

const FlowerScript = preload("res://scripts/flower.gd")
const BasketScript = preload("res://scripts/basket.gd")
const PlayerScript = preload("res://scripts/player.gd")

const ROOM_SIZE := 10.0

func _ready() -> void:
	_build_lighting()
	_build_room()
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
	_add_box("Floor", Vector3(ROOM_SIZE, 0.2, ROOM_SIZE), Vector3(0, -0.1, 0), Color("#d9c6a8"), true)
	_add_box("BackWall", Vector3(ROOM_SIZE, 3.2, 0.2), Vector3(0, 1.5, -ROOM_SIZE / 2), Color("#efe6d6"), true)
	_add_box("LeftWall", Vector3(0.2, 3.2, ROOM_SIZE), Vector3(-ROOM_SIZE / 2, 1.5, 0), Color("#e8ddca"), true)
	_add_box("RightWall", Vector3(0.2, 3.2, ROOM_SIZE), Vector3(ROOM_SIZE / 2, 1.5, 0), Color("#e8ddca"), true)
	_add_box("FrontWall", Vector3(ROOM_SIZE, 3.2, 0.2), Vector3(0, 1.5, ROOM_SIZE / 2), Color("#efe6d6"), true)
	_add_box("Counter", Vector3(3.0, 0.9, 0.8), Vector3(0, 0.45, -2.5), Color("#a87552"), true)
	_add_box("Shelf", Vector3(4.2, 1.8, 0.35), Vector3(-2.7, 0.9, -4.25), Color("#9a694a"), true)
	_add_box("ShelfBoard1", Vector3(4.2, 0.12, 0.5), Vector3(-2.7, 0.7, -4.0), Color("#bc8b62"), true)
	_add_box("ShelfBoard2", Vector3(4.2, 0.12, 0.5), Vector3(-2.7, 1.35, -4.0), Color("#bc8b62"), true)

func _build_level_objects() -> void:
	var types: Array[String] = ["rose", "tulip", "daisy"]
	for type_index in types.size():
		var flower_type := types[type_index]
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		var basket := BasketScript.new()
		basket.setup(flower_type, tint)
		basket.position = Vector3(-3.2 + type_index * 3.2, 0, 1.8)
		add_child(basket)
		for flower_index in range(GameState.TARGET_PER_TYPE):
			var flower_id := "%s_%02d" % [flower_type, flower_index + 1]
			if flower_id in GameState.placed_ids or flower_id in GameState.inventory:
				continue
			var flower := FlowerScript.new()
			flower.setup(flower_id, flower_type, tint)
			var row := flower_index / 5
			var column := flower_index % 5
			flower.position = Vector3(-4.3 + float(column) * 0.65 + float(type_index) * 3.0, 0, 0.4 + float(row) * 1.05)
			add_child(flower)

func _build_player() -> void:
	var player := PlayerScript.new()
	player.position = Vector3(0, 0, 3.7)
	add_child(player)

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
