extends Node

signal changed
signal notice(message: String)
signal picked_up
signal placement_rejected
signal placed_correctly
signal completed

const SCHEMA_VERSION := 1
const MAX_CARRY := 5
const FLOWER_TYPES := {
	"rose": {"name": "Hoa hồng", "color": Color("#d96b78")},
	"tulip": {"name": "Hoa tulip", "color": Color("#e6a34e")},
	"daisy": {"name": "Hoa cúc", "color": Color("#f2d976")},
	"sunflower": {"name": "Hoa hướng dương", "color": Color("#edbd48")},
	"lavender": {"name": "Hoa oải hương", "color": Color("#9d82c4")},
	"peony": {"name": "Hoa mẫu đơn", "color": Color("#e995ae")},
	"orchid": {"name": "Hoa lan", "color": Color("#b266aa")},
	"lily": {"name": "Hoa ly", "color": Color("#f2eee0")},
	"cosmos": {"name": "Hoa sao nhái", "color": Color("#e785a3")},
}

var inventory: Array[String] = []
var placed_ids: Array[String] = []
var _level_id := LevelConfig.DEMO
var _save_pending := false

func _ready() -> void:
	load_game()

func _notification(what: int) -> void:
	if _save_pending and (what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST):
		save_game()

func level_id() -> String:
	return _level_id

func level_profile() -> Dictionary:
	return LevelConfig.PROFILES[_level_id]

func choose_level(id: String) -> bool:
	if not LevelConfig.PROFILES.has(id):
		return false
	if id == _level_id:
		return true
	if _save_pending and not save_game():
		return false
	_level_id = id
	load_game()
	return true

func save_path() -> String:
	return str(level_profile().save_base) + ".json"

func has_save_files() -> bool:
	return FileAccess.file_exists(save_path()) or FileAccess.file_exists(str(level_profile().save_base) + ".bak")

func pickup(flower_id: String) -> bool:
	if is_complete() or not _is_valid_flower_id(flower_id):
		return false
	if inventory.size() >= MAX_CARRY:
		notice.emit("Tay đang đầy")
		return false
	if flower_id in inventory or flower_id in placed_ids:
		return false
	inventory.append(flower_id)
	_save_and_notify()
	picked_up.emit()
	return true

func place_one(flower_type: String) -> bool:
	var index := -1
	for i in inventory.size():
		if flower_type_from_id(inventory[i]) == flower_type:
			index = i
			break
	if index < 0:
		if not inventory.is_empty():
			placement_rejected.emit()
		notice.emit("Hãy mang " + type_name(flower_type) + " đến đây")
		return false
	var flower_id := inventory[index]
	if placed_count(flower_type) >= flower_target(flower_type):
		notice.emit("Giỏ " + type_name(flower_type) + " đã đầy")
		return false
	inventory.remove_at(index)
	placed_ids.append(flower_id)
	_save_and_notify()
	placed_correctly.emit()
	if is_complete():
		completed.emit()
	return true

func flower_type_from_id(flower_id: String) -> String:
	return flower_id.get_slice("_", 0)

func type_name(flower_type: String) -> String:
	return str(FLOWER_TYPES.get(flower_type, {"name": "hoa"}).name)

func flower_target(flower_type: String) -> int:
	return int(level_profile().flowers_per_type) if FLOWER_TYPES.has(flower_type) else 0

func total_flowers() -> int:
	return FLOWER_TYPES.size() * int(level_profile().flowers_per_type)

func progress_text() -> String:
	return "Đã xếp %d/%d" % [placed_ids.size(), total_flowers()]

func placed_count(flower_type: String) -> int:
	var count := 0
	for flower_id in placed_ids:
		if flower_type_from_id(flower_id) == flower_type:
			count += 1
	return count

func is_complete() -> bool:
	return placed_ids.size() >= total_flowers()

func has_progress() -> bool:
	return not inventory.is_empty() or not placed_ids.is_empty()

func _is_valid_flower_id(flower_id: String) -> bool:
	var parts := flower_id.split("_")
	if parts.size() != 2 or not FLOWER_TYPES.has(parts[0]) or not parts[1].is_valid_int():
		return false
	var number := int(parts[1])
	return number >= 1 and number <= flower_target(parts[0])

func _save_and_notify() -> void:
	_save_pending = true
	if not save_game():
		notice.emit("Không lưu được tiến độ. Hãy kiểm tra dung lượng thiết bị.")
	changed.emit()

func save_game() -> bool:
	var profile := level_profile()
	var base := str(profile.save_base)
	var primary_path := base + ".json"
	var temp_path := base + ".tmp"
	var backup_path := base + ".bak"
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	if file == null:
		push_warning("Could not open temporary save file")
		return false
	file.store_string(JSON.stringify({
		"schema_version": SCHEMA_VERSION,
		"level_id": _level_id,
		"layout_version": profile.layout_version,
		"inventory": inventory,
		"placed_ids": placed_ids,
	}))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		_remove_save_file(temp_path)
		push_warning("Could not flush temporary save file")
		return false

	# Keep an existing recovery copy when the primary cannot be read.
	if FileAccess.file_exists(primary_path) and _is_save_valid(_read_save(primary_path)):
		if DirAccess.copy_absolute(primary_path, backup_path) != OK:
			_remove_save_file(temp_path)
			push_warning("Could not preserve previous save file")
			return false
	if DirAccess.rename_absolute(temp_path, primary_path) != OK:
		_remove_save_file(temp_path)
		push_warning("Could not replace save file")
		return false
	_remove_save_file(backup_path)
	_save_pending = false
	return true

func _remove_save_file(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _read_save(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return null
	return json.data

func _is_save_valid(parsed: Variant) -> bool:
	if not parsed is Dictionary or parsed.get("schema_version", 0) != SCHEMA_VERSION:
		return false
	if not parsed.get("inventory") is Array or not parsed.get("placed_ids") is Array:
		return false
	# Untagged schema 1 files are the original 504-flower layout.
	if not parsed.has("level_id") and not parsed.has("layout_version"):
		return _level_id == LevelConfig.STRESS and level_profile().layout_version == 1
	if parsed.get("level_id") != _level_id:
		return false
	var saved_layout: Variant = parsed.get("layout_version")
	# D1 demo saves store flower IDs, so the entrance layout can reuse all progress.
	return saved_layout == level_profile().layout_version or (_level_id == LevelConfig.DEMO and saved_layout == 1)

func load_game() -> void:
	inventory.clear()
	placed_ids.clear()
	var parsed: Variant = _read_save(save_path())
	if not _is_save_valid(parsed):
		parsed = _read_save(str(level_profile().save_base) + ".bak")
	if not _is_save_valid(parsed):
		return
	var raw_inventory: Variant = parsed.get("inventory", [])
	var raw_placed: Variant = parsed.get("placed_ids", [])
	var restored_inventory: Array[String] = []
	var restored_placed: Array[String] = []
	var seen_ids: Dictionary = {}
	for flower_id in raw_inventory:
		if flower_id is String and _is_valid_flower_id(flower_id) and not seen_ids.has(flower_id) and restored_inventory.size() < MAX_CARRY:
			restored_inventory.append(flower_id)
			seen_ids[flower_id] = true
	for flower_id in raw_placed:
		if not (flower_id is String and _is_valid_flower_id(flower_id)):
			continue
		var flower_type := flower_type_from_id(flower_id)
		var type_count := 0
		for already_placed in restored_placed:
			if flower_type_from_id(already_placed) == flower_type:
				type_count += 1
		if not seen_ids.has(flower_id) and type_count < flower_target(flower_type):
			restored_placed.append(flower_id)
			seen_ids[flower_id] = true
	inventory = restored_inventory
	placed_ids = restored_placed

func reset_game() -> bool:
	var old_inventory := inventory.duplicate()
	var old_placed := placed_ids.duplicate()
	inventory.clear()
	placed_ids.clear()
	if not save_game():
		inventory.assign(old_inventory)
		placed_ids.assign(old_placed)
		notice.emit("Không thể xóa tiến độ. Hãy kiểm tra dung lượng thiết bị.")
		return false
	changed.emit()
	return true
