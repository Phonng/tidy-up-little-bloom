extends Node

const SETTINGS_PATH := "user://settings.cfg"

var look_sensitivity := 1.0
var invert_y := false
var music_volume := 0.7
var sfx_volume := 0.8

func _ready() -> void:
	_ensure_audio_bus("Music")
	_ensure_audio_bus("SFX")
	load_settings()
	_apply_audio()

func _ensure_audio_bus(bus_name: String) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index == -1:
		index = AudioServer.bus_count
		AudioServer.add_bus(index)
		AudioServer.set_bus_name(index, bus_name)
	AudioServer.set_bus_send(index, "Master")

func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	look_sensitivity = clampf(float(config.get_value("controls", "look_sensitivity", 1.0)), 0.5, 2.0)
	invert_y = bool(config.get_value("controls", "invert_y", false))
	music_volume = clampf(float(config.get_value("audio", "music_volume", 0.7)), 0.0, 1.0)
	sfx_volume = clampf(float(config.get_value("audio", "sfx_volume", 0.8)), 0.0, 1.0)

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("controls", "look_sensitivity", look_sensitivity)
	config.set_value("controls", "invert_y", invert_y)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_warning("Could not save settings")

func set_look_sensitivity(value: float) -> void:
	look_sensitivity = clampf(value, 0.5, 2.0)
	save_settings()

func set_invert_y(value: bool) -> void:
	invert_y = value
	save_settings()

func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_apply_audio()
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_apply_audio()
	save_settings()

func _apply_audio() -> void:
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func _set_bus_volume(bus_name: String, linear_volume: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index >= 0:
		var decibels := -80.0 if linear_volume <= 0.001 else linear_to_db(linear_volume)
		AudioServer.set_bus_volume_db(index, decibels)
