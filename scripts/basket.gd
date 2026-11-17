extends StaticBody3D
class_name FlowerBasket

var flower_type := "rose"
var tint := Color("#d96b78")

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
	var label := MeshInstance3D.new()
	var label_mesh := BoxMesh.new()
	label_mesh.size = Vector3(0.38, 0.12, 0.04)
	label.mesh = label_mesh
	label.position = Vector3(0, 0.57, -0.34)
	label.material_override = _material(tint)
	add_child(label)

func interact(_actor: Node) -> void:
	GameState.place_one(flower_type)

func focus_text() -> String:
	return "Đặt " + GameState.type_name(flower_type)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material
