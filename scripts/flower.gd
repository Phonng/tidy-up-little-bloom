extends StaticBody3D
class_name FlowerPickup

var flower_id := "rose_01"
var flower_type := "rose"
var tint := Color("#d96b78")

func setup(id: String, type: String, color: Color) -> void:
	flower_id = id
	flower_type = type
	tint = color

func _ready() -> void:
	add_to_group("interactables")
	collision_layer = 2
	var shape := SphereShape3D.new()
	shape.radius = 0.24
	var collision := CollisionShape3D.new()
	collision.shape = shape
	collision.position.y = 0.32
	add_child(collision)
	var stem := MeshInstance3D.new()
	var stem_mesh := CylinderMesh.new()
	stem_mesh.top_radius = 0.025
	stem_mesh.bottom_radius = 0.035
	stem_mesh.height = 0.48
	stem.mesh = stem_mesh
	stem.position.y = 0.23
	stem.material_override = _material(Color("#5c9567"))
	add_child(stem)
	_add_leaf(Vector3(-0.07, 0.24, 0), -24.0)
	_add_leaf(Vector3(0.07, 0.32, 0), 24.0)
	_add_flower_head()

func interact(_actor: Node) -> void:
	if GameState.pickup(flower_id):
		queue_free()

func focus_text() -> String:
	return "Nhặt " + GameState.type_name(flower_type)

func _add_leaf(at: Vector3, angle: float) -> void:
	var leaf := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radial_segments = 8
	mesh.rings = 4
	leaf.mesh = mesh
	leaf.scale = Vector3(0.11, 0.035, 0.055)
	leaf.position = at
	leaf.rotation_degrees.z = angle
	leaf.material_override = _material(Color("#65936a"))
	add_child(leaf)

func _add_flower_head() -> void:
	match flower_type:
		"daisy":
			for petal_index in 8:
				var angle := TAU * float(petal_index) / 8.0
				var petal := _make_lobe(Color("#fff3dc"), Vector3(0.10, 0.035, 0.055))
				petal.position = Vector3(cos(angle) * 0.095, 0.48, sin(angle) * 0.095)
				petal.rotation.y = -angle
				add_child(petal)
			var center := _make_lobe(Color("#e7b84f"), Vector3(0.075, 0.065, 0.075))
			center.position.y = 0.49
			add_child(center)
		"tulip":
			for petal_index in 5:
				var angle := TAU * float(petal_index) / 5.0
				var petal := _make_lobe(tint.lightened(0.08), Vector3(0.072, 0.115, 0.065))
				petal.position = Vector3(cos(angle) * 0.045, 0.51, sin(angle) * 0.045)
				petal.rotation.z = cos(angle) * 0.16
				petal.rotation.x = sin(angle) * 0.16
				add_child(petal)
			var center := _make_lobe(tint.darkened(0.12), Vector3(0.055, 0.105, 0.05))
			center.position.y = 0.52
			add_child(center)
		"sunflower":
			for petal_index in 10:
				var angle := TAU * float(petal_index) / 10.0
				var petal := _make_lobe(Color("#f1c84f"), Vector3(0.09, 0.045, 0.055))
				petal.position = Vector3(cos(angle) * 0.105, 0.49, sin(angle) * 0.105)
				petal.rotation.y = -angle
				add_child(petal)
			var center := _make_lobe(Color("#76543e"), Vector3(0.078, 0.07, 0.078))
			center.position.y = 0.49
			add_child(center)
		"lavender":
			for bloom_index in 5:
				var bloom := _make_lobe(Color("#a78acb"), Vector3(0.047, 0.055, 0.045))
				bloom.position = Vector3(0.0, 0.38 + float(bloom_index) * 0.055, float(bloom_index % 2) * 0.035)
				add_child(bloom)
		"peony":
			for petal_index in 10:
				var angle := TAU * float(petal_index) / 10.0
				var petal := _make_lobe(tint.lightened(0.08), Vector3(0.078, 0.07, 0.065))
				petal.position = Vector3(cos(angle) * 0.075, 0.48 + float(petal_index % 2) * 0.035, sin(angle) * 0.075)
				petal.rotation.y = -angle
				add_child(petal)
			var center := _make_lobe(tint.darkened(0.12), Vector3(0.055, 0.06, 0.055))
			center.position.y = 0.52
			add_child(center)
		_:
			for petal_index in 6:
				var angle := TAU * float(petal_index) / 6.0
				var petal := _make_lobe(tint.lightened(0.1), Vector3(0.075, 0.07, 0.07))
				petal.position = Vector3(cos(angle) * 0.045, 0.49, sin(angle) * 0.045)
				add_child(petal)
			var center := _make_lobe(tint.darkened(0.1), Vector3(0.06, 0.055, 0.06))
			center.position.y = 0.54
			add_child(center)

func _make_lobe(color: Color, size: Vector3) -> MeshInstance3D:
	var lobe := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radial_segments = 8
	mesh.rings = 4
	lobe.mesh = mesh
	lobe.scale = size
	lobe.material_override = _material(color)
	return lobe

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material
