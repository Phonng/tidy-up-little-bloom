extends StaticBody3D
class_name FlowerPickup

var flower_id := "rose_001"
var flower_type := "rose"
var tint := Color("#d96b78")
var _stem_batch: MultiMeshInstance3D
var _stem_index := -1
var _bloom_batch: MultiMeshInstance3D
var _bloom_index := -1

static func build_stem_mesh() -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var stem := CylinderMesh.new()
	stem.top_radius = 0.025
	stem.bottom_radius = 0.035
	stem.height = 0.48
	_append_part(surface, stem, Vector3(0, 0.23, 0), Vector3.ONE)
	var leaf := SphereMesh.new()
	leaf.radial_segments = 8
	leaf.rings = 4
	_append_part(surface, leaf, Vector3(-0.07, 0.24, 0), Vector3(0.22, 0.07, 0.11), Vector3(0, 0, deg_to_rad(-24)))
	_append_part(surface, leaf, Vector3(0.07, 0.32, 0), Vector3(0.22, 0.07, 0.11), Vector3(0, 0, deg_to_rad(24)))
	return surface.commit()

static func build_bloom_mesh(flower_type: String) -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var lobe := SphereMesh.new()
	lobe.radial_segments = 8
	lobe.rings = 4
	match flower_type:
		"daisy":
			for index in 8:
				var angle := TAU * float(index) / 8.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.095, 0.48, sin(angle) * 0.095), Vector3(0.20, 0.07, 0.11), Vector3(0, -angle, 0))
		"tulip":
			for index in 5:
				var angle := TAU * float(index) / 5.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.045, 0.51, sin(angle) * 0.045), Vector3(0.144, 0.23, 0.13), Vector3(sin(angle) * 0.16, -angle, cos(angle) * 0.16))
		"sunflower":
			for index in 10:
				var angle := TAU * float(index) / 10.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.105, 0.49, sin(angle) * 0.105), Vector3(0.18, 0.09, 0.11), Vector3(0, -angle, 0))
		"lavender":
			for index in 5:
				_append_part(surface, lobe, Vector3(0, 0.39 + float(index) * 0.055, float(index % 2) * 0.035), Vector3(0.094, 0.11, 0.09))
		"peony":
			for index in 10:
				var angle := TAU * float(index) / 10.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.075, 0.48 + float(index % 2) * 0.035, sin(angle) * 0.075), Vector3(0.156, 0.14, 0.13), Vector3(0, -angle, 0))
		"orchid":
			for index in 5:
				var angle := TAU * float(index) / 5.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.07, 0.49, sin(angle) * 0.07), Vector3(0.15, 0.09, 0.19), Vector3(0, -angle, 0))
		"lily":
			for index in 6:
				var angle := TAU * float(index) / 6.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.09, 0.49, sin(angle) * 0.09), Vector3(0.12, 0.08, 0.23), Vector3(0, -angle, 0))
		"cosmos":
			for index in 8:
				var angle := TAU * float(index) / 8.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.10, 0.49, sin(angle) * 0.10), Vector3(0.19, 0.07, 0.10), Vector3(0, -angle, 0))
		_:
			for index in 7:
				var angle := TAU * float(index) / 7.0
				_append_part(surface, lobe, Vector3(cos(angle) * 0.045, 0.49, sin(angle) * 0.045), Vector3(0.15, 0.14, 0.14), Vector3(0, -angle, 0))
	_append_part(surface, lobe, Vector3(0, 0.51, 0), Vector3(0.12, 0.12, 0.12))
	return surface.commit()

static func _append_part(surface: SurfaceTool, mesh: Mesh, at: Vector3, scale: Vector3, rotation: Vector3 = Vector3.ZERO) -> void:
	var basis := Basis.from_euler(rotation) * Basis.from_scale(scale)
	surface.append_from(mesh, 0, Transform3D(basis, at))

func setup(id: String, type: String, color: Color) -> void:
	flower_id = id
	flower_type = type
	tint = color

func set_visual_batches(stem_batch: MultiMeshInstance3D, stem_index: int, bloom_batch: MultiMeshInstance3D, bloom_index: int) -> void:
	_stem_batch = stem_batch
	_stem_index = stem_index
	_bloom_batch = bloom_batch
	_bloom_index = bloom_index

func _ready() -> void:
	add_to_group("interactables")
	collision_layer = 2
	var shape := SphereShape3D.new()
	shape.radius = 0.24
	var collision := CollisionShape3D.new()
	collision.shape = shape
	collision.position.y = 0.32
	add_child(collision)

func interact(_actor: Node) -> void:
	if GameState.pickup(flower_id):
		_hide_batch_instance(_stem_batch, _stem_index)
		_hide_batch_instance(_bloom_batch, _bloom_index)
		queue_free()

func focus_text() -> String:
	return "Nhặt " + GameState.type_name(flower_type)

func _hide_batch_instance(batch: MultiMeshInstance3D, index: int) -> void:
	if is_instance_valid(batch) and batch.multimesh != null and index >= 0:
		var hidden := Transform3D(Basis.from_scale(Vector3.ZERO), Vector3(0, -1000, 0))
		batch.multimesh.set_instance_transform(index, hidden)
