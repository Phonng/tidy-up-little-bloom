extends Node3D
class_name FlowerField

const FlowerScript = preload("res://scripts/flower.gd")

var _flowers: Dictionary = {}
var _records_by_id: Dictionary = {}
var _hidden_ids: Dictionary = {}
var _stem_batch: MultiMeshInstance3D
var _bloom_batches: Dictionary = {}

func _ready() -> void:
	add_to_group("flower_field")

func initialize(flowers_by_type: Dictionary) -> void:
	_flowers = flowers_by_type
	var stem_positions: Array[Vector3] = []
	for flower_type in _flowers:
		var records: Array = _flowers[flower_type]
		for record_value in records:
			var record: Dictionary = record_value
			record["type"] = flower_type
			_records_by_id[record["id"]] = record
			stem_positions.append(record["position"])
	_stem_batch = _create_batch(
		FlowerScript.build_stem_mesh(), stem_positions, _material(Color("#5c9567")), "SharedFlowerStems"
	)
	var stem_index := 0
	for flower_type in _flowers:
		var records: Array = _flowers[flower_type]
		var bloom_positions: Array[Vector3] = []
		for record_value in records:
			var record: Dictionary = record_value
			bloom_positions.append(record["position"])
		var tint: Color = GameState.FLOWER_TYPES[flower_type].color
		var bloom_batch := _create_batch(
			FlowerScript.build_bloom_mesh(flower_type),
			bloom_positions,
			_material(tint),
			"BloomBatch_" + flower_type
		)
		_bloom_batches[flower_type] = bloom_batch
		for index in records.size():
			var record: Dictionary = records[index]
			var flower_id: String = record["id"]
			record["stem_index"] = stem_index
			record["bloom_index"] = index
			stem_index += 1

func focused_flower(origin: Vector3, direction: Vector3, max_distance: float) -> String:
	var ray_direction := direction.normalized()
	var best_id := ""
	var best_distance := max_distance
	for flower_id in _records_by_id:
		if _hidden_ids.has(flower_id):
			continue
		var record: Dictionary = _records_by_id[flower_id]
		var flower_position: Vector3 = record["position"] + Vector3(0, 0.48, 0)
		var to_flower := global_transform * flower_position - origin
		var along_ray := to_flower.dot(ray_direction)
		if along_ray <= 0.0 or along_ray >= best_distance:
			continue
		var perpendicular := to_flower - ray_direction * along_ray
		if perpendicular.length_squared() <= 0.22 * 0.22:
			best_distance = along_ray
			best_id = flower_id
	return best_id

func focus_text(flower_id: String) -> String:
	var record: Dictionary = _records_by_id.get(flower_id, {})
	return "Nhặt " + GameState.type_name(str(record.get("type", "")))

func interact(flower_id: String) -> void:
	if not _records_by_id.has(flower_id) or _hidden_ids.has(flower_id):
		return
	if not GameState.pickup(flower_id):
		return
	_hidden_ids[flower_id] = true
	var record: Dictionary = _records_by_id[flower_id]
	_hide_instance(_stem_batch, int(record["stem_index"]))
	var flower_type: String = record["type"]
	_hide_instance(_bloom_batches[flower_type], int(record["bloom_index"]))

func _create_batch(mesh: Mesh, positions: Array[Vector3], material: Material, batch_name: String) -> MultiMeshInstance3D:
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

func _hide_instance(batch: MultiMeshInstance3D, index: int) -> void:
	if is_instance_valid(batch) and batch.multimesh != null and index >= 0:
		batch.multimesh.set_instance_transform(
			index,
			Transform3D(Basis.from_scale(Vector3.ZERO), Vector3(0, -1000, 0))
		)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material
