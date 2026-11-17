extends Node

signal changed
signal notice(message: String)
signal completed

const SAVE_PATH := "user://little_bloom_save.json"
const MAX_CARRY := 5
const TARGET_PER_TYPE := 10
const FLOWER_TYPES := {
	"rose": {"name": "Hoa hồng", "color": Color("#d96b78")},
	"tulip": {"name": "Hoa tulip", "color": Color("#e6a34e")},
	"daisy": {"name": "Hoa cúc", "color": Color("#f2d976")},
}

var inventory: Array[String] = []
var placed_ids: Array[String] = []

func _ready() -> void:
	load_game()

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
	return true

func place_one(flower_type: String) -> bool:
	var index := -1
	for i in inventory.size():
		if flower_type_from_id(inventory[i]) == flower_type:
			index = i
			break
	if index < 0:
		notice.emit("Hãy mang " + type_name(flower_type) + " đến đây")
		return false
	var flower_id := inventory[index]
	if placed_count(flower_type) >= TARGET_PER_TYPE:
		notice.emit("Giỏ " + type_name(flower_type) + " đã đầy")
		return false
	inventory.remove_at(index)
	placed_ids.append(flower_id)
	_save_and_notify()
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

func _is_valid_flower_id(flower_id: String) -> bool:
	var parts := flower_id.split("_")
	if parts.size() != 2 or not FLOWER_TYPES.has(parts[0]) or not parts[1].is_valid_int():
		return false
	var number := int(parts[1])
	return number >= 1 and number <= TARGET_PER_TYPE

func _save_and_notify() -> void:
	save_game()
	changed.emit()

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Could not write save file")
		return
	file.store_string(JSON.stringify({"schema_version": 1, "inventory": inventory, "placed_ids": placed_ids}))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or parsed.get("schema_version", 0) != 1:
		return
	var raw_inventory: Variant = parsed.get("inventory", [])
	var raw_placed: Variant = parsed.get("placed_ids", [])
	if not raw_inventory is Array or not raw_placed is Array:
		return
	for flower_id in raw_inventory:
		if flower_id is String and _is_valid_flower_id(flower_id) and flower_id not in inventory and inventory.size() < MAX_CARRY:
			inventory.append(flower_id)
	for flower_id in raw_placed:
		if flower_id is String and _is_valid_flower_id(flower_id) and flower_id not in inventory and flower_id not in placed_ids and placed_count(flower_type_from_id(flower_id)) < TARGET_PER_TYPE:
			placed_ids.append(flower_id)

func reset_game() -> void:
	inventory.clear()
	placed_ids.clear()
	_save_and_notify()
