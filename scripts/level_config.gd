extends RefCounted
class_name LevelConfig

const DEMO := "demo"
const STRESS := "stress"
const UPPER_FLOOR_Y := 4.2
const INTERACTION_ONLY_LAYER := 4
const INTERACTION_MASK := 1 | 2 | INTERACTION_ONLY_LAYER

const PROFILES := {
	DEMO: {
		"label": "Demo · 90 bông",
		"flowers_per_type": 10,
		"seed": 20261119,
		"layout_version": 2,
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

const DEMO_ROSE_BASKET := Vector3(4.16, 0.0, 6.65)
const DEMO_SPAWN := Vector3(3.9, 0.05, 9.8)
const DEMO_STARTER_AREA := Rect2(2.4, 5.0, 3.6, 4.5)
const DEMO_ROSE_SPOTS := [
	Vector3(3.42, 0.0, 8.8),
	Vector3(4.25, 0.0, 8.55),
	Vector3(5.35, 0.0, 8.85),
	Vector3(2.75, 0.0, 8.0),
	Vector3(4.88, 0.0, 7.94),
	Vector3(3.42, 0.0, 7.15),
	Vector3(5.48, 0.0, 7.0),
	Vector3(2.77, 0.0, 6.3),
	Vector3(4.98, 0.0, 5.78),
	Vector3(3.52, 0.0, 5.43),
]

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
