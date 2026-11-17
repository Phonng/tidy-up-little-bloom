extends StaticBody3D
class_name FlowerBasket

var flower_type := "rose"
var tint := Color("#d96b78")
var contents_root: Node3D
var drawn_count := -1

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
	GameState.changed.connect(_sync_contents)
	_sync_contents()

func interact(_actor: Node) -> void:
	GameState.place_one(flower_type)

func focus_text() -> String:
	return "Đặt " + GameState.type_name(flower_type)

func _sync_contents() -> void:
	var count := GameState.placed_count(flower_type)
	if count == drawn_count:
		return
	drawn_count = count
	for child in contents_root.get_children():
		contents_root.remove_child(child)
		child.queue_free()
	for index in count:
		var flower := Node3D.new()
		var column := index % 5
		var row := index / 5
		flower.position = Vector3(-0.25 + float(column) * 0.125, 0.54 + float(row) * 0.11, -0.18 + float(row) * 0.26)
		var stem := MeshInstance3D.new()
		var stem_mesh := CylinderMesh.new()
		stem_mesh.top_radius = 0.009
		stem_mesh.bottom_radius = 0.014
		stem_mesh.height = 0.13
		stem.mesh = stem_mesh
		stem.position.y = 0.06
		stem.material_override = _material(Color("#5c9567"))
		flower.add_child(stem)
		var bloom := MeshInstance3D.new()
		var bloom_mesh := SphereMesh.new()
		bloom_mesh.radius = 0.065
		bloom_mesh.height = 0.11
		bloom.mesh = bloom_mesh
		bloom.position.y = 0.15
		bloom.material_override = _material(tint)
		flower.add_child(bloom)
		contents_root.add_child(flower)

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
