extends Node3D
class_name FlowerField

const FlowerScript = preload("res://scripts/flower.gd")
const GRID_CELL_SIZE := 2.0

var _records_by_id: Dictionary = {}
var _hidden_ids: Dictionary = {}
var _ids_by_cell: Dictionary = {}
var _chunk_records: Dictionary = {}
var _stem_batches: Dictionary = {}
var _bloom_batches: Dictionary = {}


func _ready() -> void:
	add_to_group("flower_field")


func initialize(flowers_by_type: Dictionary) -> void:
	for flower_type_value in flowers_by_type:
		var flower_type: String = str(flower_type_value)
		var records: Array = flowers_by_type[flower_type_value]
		for record_value in records:
			var record: Dictionary = record_value
			record["type"] = flower_type
			var flower_id: String = str(record["id"])
			var position: Vector3 = record["position"]
			var chunk_key := _chunk_key(position)
			record["chunk_key"] = chunk_key
			_records_by_id[flower_id] = record
			if not _chunk_records.has(chunk_key):
				_chunk_records[chunk_key] = []
			_chunk_records[chunk_key].append(record)
			_add_to_spatial_grid(flower_id, position)

	_build_chunk_batches()


func focused_flower(origin: Vector3, direction: Vector3, max_distance: float) -> String:
	var ray_direction := direction.normalized()
	var local_origin := global_transform.affine_inverse() * origin
	var local_direction := (global_transform.basis.inverse() * ray_direction).normalized()
	var candidate_ids: Dictionary = {}
	var sample_step := GRID_CELL_SIZE * 0.5
	var sample_count := ceili(max_distance / sample_step)

	for sample_index in range(sample_count + 1):
		var sample_distance := minf(float(sample_index) * sample_step, max_distance)
		var sample_position := local_origin + local_direction * sample_distance
		var cell_x := floori(sample_position.x / GRID_CELL_SIZE)
		var cell_z := floori(sample_position.z / GRID_CELL_SIZE)
		for offset_x in range(-1, 2):
			for offset_z in range(-1, 2):
				var cell_key := Vector2i(cell_x + offset_x, cell_z + offset_z)
				var cell_ids: Array = _ids_by_cell.get(cell_key, [])
				for flower_id_value in cell_ids:
					candidate_ids[flower_id_value] = true

	var best_id := ""
	var best_distance := max_distance
	for flower_id_value in candidate_ids:
		var flower_id: String = str(flower_id_value)
		if _hidden_ids.has(flower_id):
			continue
		var record: Dictionary = _records_by_id[flower_id]
		var flower_position: Vector3 = global_transform * (record["position"] + Vector3(0, 0.48, 0))
		var to_flower := flower_position - origin
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
	var chunk_key: String = record["chunk_key"]
	_hide_instance(_stem_batches[chunk_key], int(record["stem_index"]))
	var bloom_key := _bloom_key(chunk_key, str(record["type"]))
	_hide_instance(_bloom_batches[bloom_key], int(record["bloom_index"]))


func _build_chunk_batches() -> void:
	var stem_mesh: Mesh = FlowerScript.build_stem_mesh()
	var stem_material: Material = _material(Color("#5c9567"))
	var bloom_meshes: Dictionary = {}
	var bloom_materials: Dictionary = {}
	for chunk_key_value in _chunk_records:
		var chunk_key: String = str(chunk_key_value)
		var chunk_records: Array = _chunk_records[chunk_key_value]
		var stem_positions: Array[Vector3] = []
		var records_by_type: Dictionary = {}
		for record_value in chunk_records:
			var record: Dictionary = record_value
			stem_positions.append(record["position"])
			var flower_type: String = record["type"]
			if not records_by_type.has(flower_type):
				records_by_type[flower_type] = []
			records_by_type[flower_type].append(record)

		var stem_batch := _create_batch(
			stem_mesh,
			stem_positions,
			stem_material,
			"Stems_" + chunk_key
		)
		_stem_batches[chunk_key] = stem_batch
		for index in chunk_records.size():
			var record: Dictionary = chunk_records[index]
			record["stem_index"] = index

		for flower_type_value in records_by_type:
			var flower_type: String = str(flower_type_value)
			var type_records: Array = records_by_type[flower_type_value]
			if not bloom_meshes.has(flower_type):
				bloom_meshes[flower_type] = FlowerScript.build_bloom_mesh(flower_type)
				var tint: Color = GameState.FLOWER_TYPES[flower_type].color
				bloom_materials[flower_type] = _material(tint)
			var bloom_positions: Array[Vector3] = []
			for record_value in type_records:
				var record: Dictionary = record_value
				bloom_positions.append(record["position"])
			var bloom_key := _bloom_key(chunk_key, flower_type)
			var bloom_batch := _create_batch(
				bloom_meshes[flower_type],
				bloom_positions,
				bloom_materials[flower_type],
				"Blooms_" + bloom_key
			)
			_bloom_batches[bloom_key] = bloom_batch
			for index in type_records.size():
				var record: Dictionary = type_records[index]
				record["bloom_index"] = index


func _chunk_key(position: Vector3) -> String:
	var floor_index := 1 if position.y > 2.0 else 0
	var chunk_x := 1 if position.x >= 0.0 else 0
	var chunk_z := 1 if position.z >= 0.0 else 0
	return "%d_%d_%d" % [floor_index, chunk_x, chunk_z]


func _bloom_key(chunk_key: String, flower_type: String) -> String:
	return chunk_key + "|" + flower_type


func _add_to_spatial_grid(flower_id: String, position: Vector3) -> void:
	var cell_key := Vector2i(
		floori(position.x / GRID_CELL_SIZE),
		floori(position.z / GRID_CELL_SIZE)
	)
	if not _ids_by_cell.has(cell_key):
		_ids_by_cell[cell_key] = []
	_ids_by_cell[cell_key].append(flower_id)


func _create_batch(
		mesh: Mesh,
		positions: Array[Vector3],
		material: Material,
		batch_name: String
) -> MultiMeshInstance3D:
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
