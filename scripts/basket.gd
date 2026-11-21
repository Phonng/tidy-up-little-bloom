extends StaticBody3D
class_name FlowerBasket

const FlowerScript = preload("res://scripts/flower.gd")

var flower_type := "rose"
var tint := Color("#d96b78")
var contents_root: Node3D
var drawn_count := -1
var _placed_stems: MultiMesh
var _placed_blooms: MultiMesh
var _starter_label: Label3D

func setup(type: String, color: Color) -> void:
	flower_type = type
	tint = color

func _ready() -> void:
	add_to_group("interactables")
	# Layer 1 blocks the player; layer 2 keeps the basket targetable by the camera ray.
	collision_layer = 3
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.8, 0.55, 0.65)
	var collision := CollisionShape3D.new()
	collision.shape = shape
	collision.position.y = 0.28
	add_child(collision)
	var body := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.8, 0.5, 0.65)
	body.mesh = mesh
	body.position.y = 0.26
	body.material_override = _material(Color("#c99465"))
	add_child(body)
	for level in 3:
		var slat_y := 0.12 + float(level) * 0.15
		_add_wood_slat(Vector3(0, slat_y, 0.335), Vector3(0.82, 0.035, 0.035), Color("#a9774e"))
		_add_wood_slat(Vector3(0, slat_y, -0.335), Vector3(0.82, 0.035, 0.035), Color("#a9774e"))
		_add_wood_slat(Vector3(0.405, slat_y, 0), Vector3(0.035, 0.035, 0.65), Color("#b98558"))
		_add_wood_slat(Vector3(-0.405, slat_y, 0), Vector3(0.035, 0.035, 0.65), Color("#b98558"))
	_add_wood_slat(Vector3(0, 0.52, 0), Vector3(0.86, 0.07, 0.72), Color("#d6b17c"))
	var label := MeshInstance3D.new()
	var label_mesh := BoxMesh.new()
	label_mesh.size = Vector3(0.38, 0.12, 0.04)
	label.mesh = label_mesh
	label.position = Vector3(0, 0.57, 0.35)
	label.material_override = _material(tint)
	add_child(label)
	contents_root = Node3D.new()
	contents_root.name = "PlacedFlowers"
	add_child(contents_root)
	_placed_stems = _make_contents_batch(FlowerScript.build_stem_mesh(), Color("#5c9567"))
	_placed_blooms = _make_contents_batch(FlowerScript.build_bloom_mesh(flower_type), tint)
	if GameState.level_id() == LevelConfig.DEMO and flower_type == "rose":
		_starter_label = Label3D.new()
		_starter_label.position.y = 0.96
		_starter_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		_starter_label.font_size = 40
		_starter_label.pixel_size = 0.0034
		_starter_label.modulate = Color("#fff1dc")
		_starter_label.outline_modulate = Color("#503d33")
		add_child(_starter_label)
	GameState.changed.connect(_sync_contents)
	_sync_contents()

func interact(_actor: Node) -> void:
	GameState.place_one(flower_type)

func focus_text() -> String:
	return "Đặt " + GameState.type_name(flower_type)

func _make_contents_batch(mesh: Mesh, color: Color) -> MultiMesh:
	var multimesh := MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = mesh
	var visual := MultiMeshInstance3D.new()
	visual.multimesh = multimesh
	visual.material_override = _material(color)
	contents_root.add_child(visual)
	return multimesh

func _sync_contents() -> void:
	var count := GameState.placed_count(flower_type)
	if count == drawn_count:
		return
	drawn_count = count
	if is_instance_valid(_starter_label):
		var target := GameState.flower_target(flower_type)
		_starter_label.text = "Giỏ hoa hồng · %d/%d" % [count, target]
		_starter_label.modulate = Color("#dff8dc") if count == target else Color("#fff1dc")
	_placed_stems.instance_count = count
	_placed_blooms.instance_count = count
	for index in count:
		var column := index % 5
		var row := floori(float(index) / 5.0) % 5
		var layer := floori(float(index) / 25.0)
		var flower_position := Vector3(
			-0.27 + float(column) * 0.135,
			0.54 + float(layer) * 0.12,
			-0.18 + float(row) * 0.09
		)
		var flower_transform := Transform3D(
			Basis.IDENTITY.scaled(Vector3(0.4, 0.4, 0.4)),
			flower_position
		)
		_placed_stems.set_instance_transform(index, flower_transform)
		_placed_blooms.set_instance_transform(index, flower_transform)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material

func _add_wood_slat(at: Vector3, size: Vector3, color: Color) -> void:
	var slat := MeshInstance3D.new()
	var slat_mesh := BoxMesh.new()
	slat_mesh.size = size
	slat.mesh = slat_mesh
	slat.position = at
	slat.material_override = _material(color)
	add_child(slat)
