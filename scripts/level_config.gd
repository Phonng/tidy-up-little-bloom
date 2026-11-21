extends RefCounted
class_name LevelConfig

const DEMO := "demo"
const STRESS := "stress"
const UPPER_FLOOR_Y := 4.2

const PROFILES := {
	DEMO: {
		"label": "Demo · 90 bông",
		"flowers_per_type": 10,
		"seed": 20261119,
		"layout_version": 1,
		"cabinet_slots": [1, 4, 7, 10],
		"save_base": "user://little_bloom_demo_save",
	},
	STRESS: {
		"label": "Thử tải · 504 bông (save cũ)",
		"flowers_per_type": 56,
		"seed": 20261119,
		"layout_version": 1,
		"cabinet_slots": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
		"save_base": "user://little_bloom_save",
	},
}

# The order determines which flower ID belongs to each position in the legacy layout.
const BASKET_SPOTS := {
	"rose": Vector3(-9.5, 0, -7.6),
	"tulip": Vector3(9.5, 0, -7.6),
	"daisy": Vector3(-9.5, 0, -1.8),
	"sunflower": Vector3(9.5, 0, -1.8),
	"lavender": Vector3(-9.5, 0, 4.8),
	"peony": Vector3(9.5, 0, 4.8),
	"orchid": Vector3(-9.7, UPPER_FLOOR_Y, -7.8),
	"lily": Vector3(9.7, UPPER_FLOOR_Y, -7.8),
	"cosmos": Vector3(0.0, UPPER_FLOOR_Y, -2.4),
}
