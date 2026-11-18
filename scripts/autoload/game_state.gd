extends Node

signal changed
signal notice(message: String)
signal picked_up
signal placement_rejected
signal placed_correctly
signal completed

const SAVE_PATH := "user://little_bloom_save.json"
const TEMP_SAVE_PATH := "user://little_bloom_save.tmp"
const BACKUP_SAVE_PATH := "user://little_bloom_save.bak"
const SCHEMA_VERSION := 1
const MAX_CARRY := 5
const TARGET_PER_TYPE := 10
const FLOWER_TYPES := {
	"rose": {"name": "Hoa hồng", "color": Color("#d96b78")},
	"tulip": {"name": "Hoa tulip", "color": Color("#e6a34e")},
	"daisy": {"name": "Hoa cúc", "color": Color("#f2d976")},
	"sunflower": {"name": "Hoa hướng dương", "color": Color("#edbd48")},
	"lavender": {"name": "Hoa oải hương", "color": Color("#9d82c4")},
	"peony": {"name": "Hoa mẫu đơn", "color": Color("#e995ae")},
}

var inventory: Array[String] = []
var placed_ids: Array[String] = []

func _ready() -> void:
	load_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()

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
	if placed_count(flower_type) >= TARGET_PER_TYPE:
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

func progress_text() -> String:
	return "Đã xếp %d/%d" % [placed_ids.size(), FLOWER_TYPES.size() * TARGET_PER_TYPE]

func placed_count(flower_type: String) -> int:
	var count := 0
	for flower_id in placed_ids:
		if flower_type_from_id(flower_id) == flower_type:
			count += 1
	return count

func is_complete() -> bool:
	return placed_ids.size() >= FLOWER_TYPES.size() * TARGET_PER_TYPE

func has_progress() -> bool:
	return not inventory.is_empty() or not placed_ids.is_empty()

func _is_valid_flower_id(flower_id: String) -> bool:
	var parts := flower_id.split("_")
	if parts.size() != 2 or not FLOWER_TYPES.has(parts[0]) or not parts[1].is_valid_int():
		return false
	var number := int(parts[1])
	return number >= 1 and number <= TARGET_PER_TYPE

func _save_and_notify() -> void:
	if not save_game():
		notice.emit("Không lưu được tiến độ. Hãy kiểm tra dung lượng thiết bị.")
	changed.emit()

func save_game() -> bool:
	var file := FileAccess.open(TEMP_SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not open temporary save file")
		return false
	file.store_string(JSON.stringify({
		"schema_version": SCHEMA_VERSION,
		"inventory": inventory,
		"placed_ids": placed_ids,
	}))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		_remove_save_file(TEMP_SAVE_PATH)
		push_warning("Could not flush temporary save file")
		return false

	var save_absolute := ProjectSettings.globalize_path(SAVE_PATH)
	var temp_absolute := ProjectSettings.globalize_path(TEMP_SAVE_PATH)
	var backup_absolute := ProjectSettings.globalize_path(BACKUP_SAVE_PATH)
	if FileAccess.file_exists(SAVE_PATH):
		_remove_save_file(BACKUP_SAVE_PATH)
		var backup_error := DirAccess.rename_absolute(save_absolute, backup_absolute)
		if backup_error != OK:
			_remove_save_file(TEMP_SAVE_PATH)
			push_warning("Could not preserve previous save file")
			return false
	var replace_error := DirAccess.rename_absolute(temp_absolute, save_absolute)
	if replace_error != OK:
		if FileAccess.file_exists(BACKUP_SAVE_PATH):
			DirAccess.rename_absolute(backup_absolute, save_absolute)
		_remove_save_file(TEMP_SAVE_PATH)
		push_warning("Could not replace save file")
		return false
	_remove_save_file(BACKUP_SAVE_PATH)
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
	return JSON.parse_string(file.get_as_text())

func _is_save_valid(parsed: Variant) -> bool:
	if not parsed is Dictionary:
		return false
	if parsed.get("schema_version", 0) != SCHEMA_VERSION:
		return false
	return parsed.get("inventory", []) is Array and parsed.get("placed_ids", []) is Array

func load_game() -> void:
	var parsed: Variant = _read_save(SAVE_PATH)
	var recovered_from_backup := false
	if not _is_save_valid(parsed):
		var backup: Variant = _read_save(BACKUP_SAVE_PATH)
		if _is_save_valid(backup):
			parsed = backup
			recovered_from_backup = true
	if not _is_save_valid(parsed):
		if FileAccess.file_exists(SAVE_PATH) or FileAccess.file_exists(BACKUP_SAVE_PATH):
			push_warning("Save file is invalid or uses an unsupported schema")
		return
	if recovered_from_backup:
		_remove_save_file(SAVE_PATH)
		DirAccess.rename_absolute(
			ProjectSettings.globalize_path(BACKUP_SAVE_PATH),
			ProjectSettings.globalize_path(SAVE_PATH)
		)
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
		if not seen_ids.has(flower_id) and type_count < TARGET_PER_TYPE:
			restored_placed.append(flower_id)
			seen_ids[flower_id] = true
	inventory = restored_inventory
	placed_ids = restored_placed

func reset_game() -> void:
	inventory.clear()
	placed_ids.clear()
	_save_and_notify()
