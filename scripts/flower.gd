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
	var bloom := MeshInstance3D.new()
	var bloom_mesh := SphereMesh.new()
	bloom_mesh.radius = 0.15
	bloom_mesh.height = 0.25
	bloom.mesh = bloom_mesh
	bloom.position.y = 0.48
	bloom.material_override = _material(tint)
	add_child(bloom)

func interact(_actor: Node) -> void:
	if GameState.pickup(flower_id):
		queue_free()

func focus_text() -> String:
	return "Nhặt " + GameState.type_name(flower_type)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material
