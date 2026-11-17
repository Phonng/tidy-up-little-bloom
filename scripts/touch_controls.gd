extends CanvasLayer
class_name TouchControls

signal move_changed(value: Vector2)
signal look_changed(delta: Vector2)
signal interact_requested

var prompt_label: Label
var progress_label: Label
var inventory_label: Label
var detail_label: Label
var notice_label: Label
var joystick_base: ColorRect
var joystick_knob: ColorRect
var pause_overlay: Control
var pause_card: Control
var settings_panel: SettingsPanel
var reset_dialog: ConfirmationDialog
var _move_touch := -1
var _look_touch := -1
var _move_origin := Vector2.ZERO
var _move_value := Vector2.ZERO
var _interact_rect := Rect2()
var _pause_rect := Rect2()
var _completion_overlay: Control

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	GameState.changed.connect(_refresh)
	GameState.notice.connect(_show_notice)
	GameState.completed.connect(_show_complete)
	_refresh()
	if GameState.is_complete():
		_show_complete()

func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	joystick_base = ColorRect.new()
	joystick_base.color = Color(0.25, 0.24, 0.22, 0.38)
	joystick_base.size = Vector2(116, 116)
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_base.visible = false
	root.add_child(joystick_base)
	joystick_knob = ColorRect.new()
	joystick_knob.color = Color(0.95, 0.88, 0.76, 0.82)
	joystick_knob.size = Vector2(54, 54)
	joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_knob.visible = false
	root.add_child(joystick_knob)
	var reticle := Label.new()
	reticle.text = "+"
	reticle.add_theme_font_size_override("font_size", 26)
	reticle.set_anchors_preset(Control.PRESET_CENTER)
	reticle.position = Vector2(-9, -15)
	root.add_child(reticle)
	progress_label = Label.new()
	progress_label.add_theme_font_size_override("font_size", 25)
	progress_label.position = Vector2(28, 24)
	root.add_child(progress_label)
	inventory_label = Label.new()
	inventory_label.add_theme_font_size_override("font_size", 18)
	inventory_label.position = Vector2(28, 92)
	root.add_child(inventory_label)
	detail_label = Label.new()
	detail_label.add_theme_font_size_override("font_size", 16)
	detail_label.position = Vector2(28, 62)
	root.add_child(detail_label)
	prompt_label = Label.new()
	prompt_label.add_theme_font_size_override("font_size", 22)
	prompt_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	prompt_label.position = Vector2(-120, -115)
	root.add_child(prompt_label)
	notice_label = Label.new()
	notice_label.add_theme_font_size_override("font_size", 24)
	notice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	notice_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	notice_label.position = Vector2(-240, 82)
	root.add_child(notice_label)
	var interact_button := Button.new()
	interact_button.text = "NHẶT / ĐẶT"
	interact_button.custom_minimum_size = Vector2(150, 76)
	interact_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	interact_button.position = Vector2(-184, -112)
	interact_button.pressed.connect(func(): interact_requested.emit())
	root.add_child(interact_button)
	var pause_button := Button.new()
	pause_button.text = "Ⅱ"
	pause_button.custom_minimum_size = Vector2(64, 58)
	pause_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	pause_button.position = Vector2(-82, 20)
	pause_button.pressed.connect(_toggle_pause)
	root.add_child(pause_button)
	_build_pause_overlay(root)
	_build_completion_overlay(root)

func _input(event: InputEvent) -> void:
	var size := get_viewport().get_visible_rect().size
	_interact_rect = Rect2(Vector2(size.x - 200, size.y - 140), Vector2(200, 140))
	_pause_rect = Rect2(Vector2(size.x - 92, 12), Vector2(92, 78))
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < size.x * 0.42 and _move_touch == -1:
				_move_touch = event.index
				_move_origin = event.position
				_move_value = Vector2.ZERO
				joystick_base.position = _move_origin - joystick_base.size / 2.0
				joystick_knob.position = _move_origin - joystick_knob.size / 2.0
				joystick_base.visible = true
				joystick_knob.visible = true
				move_changed.emit(_move_value)
			elif event.position.x >= size.x * 0.42 and not _interact_rect.has_point(event.position) and not _pause_rect.has_point(event.position):
				_look_touch = event.index
		else:
			if event.index == _move_touch:
				_move_touch = -1
				_move_value = Vector2.ZERO
				joystick_base.visible = false
				joystick_knob.visible = false
				move_changed.emit(_move_value)
			if event.index == _look_touch:
				_look_touch = -1
	elif event is InputEventScreenDrag:
		if event.index == _move_touch:
			_move_value = ((event.position - _move_origin) / 90.0).limit_length(1.0)
			joystick_knob.position = _move_origin + _move_value * 40.0 - joystick_knob.size / 2.0
			move_changed.emit(_move_value)
		elif event.index == _look_touch:
			look_changed.emit(event.relative)

func set_prompt(value: String) -> void:
	if is_instance_valid(prompt_label):
		prompt_label.text = value

func _refresh() -> void:
	if is_instance_valid(progress_label):
		progress_label.text = GameState.progress_text()
		var totals: Array[String] = []
		for flower_type in GameState.FLOWER_TYPES:
			totals.append("%s %d/%d" % [GameState.type_name(flower_type), GameState.placed_count(flower_type), GameState.TARGET_PER_TYPE])
		detail_label.text = "   ·   ".join(PackedStringArray(totals))
		var carried_counts: Dictionary = {}
		for flower_id in GameState.inventory:
			var flower_type := GameState.flower_type_from_id(flower_id)
			carried_counts[flower_type] = int(carried_counts.get(flower_type, 0)) + 1
		var carried: Array[String] = []
		for flower_type in GameState.FLOWER_TYPES:
			if carried_counts.has(flower_type):
				carried.append("%s ×%d" % [GameState.type_name(flower_type), carried_counts[flower_type]])
		inventory_label.text = "Đang cầm %d/%d: %s" % [GameState.inventory.size(), GameState.MAX_CARRY, " · ".join(PackedStringArray(carried))]

func _show_notice(message: String) -> void:
	if not is_instance_valid(notice_label):
		return
	notice_label.text = message
	await get_tree().create_timer(1.4).timeout
	if is_instance_valid(notice_label) and notice_label.text == message:
		notice_label.text = ""

func _toggle_pause() -> void:
	if pause_overlay.visible:
		_close_pause()
	else:
		_open_pause()

func _build_pause_overlay(root: Control) -> void:
	pause_overlay = Control.new()
	pause_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_overlay.visible = false
	pause_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_overlay.z_index = 10
	root.add_child(pause_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0.12, 0.12, 0.12, 0.68)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_overlay.add_child(dim)
	pause_card = PanelContainer.new()
	pause_card.set_anchors_preset(Control.PRESET_CENTER)
	pause_card.position = Vector2(-210, -220)
	pause_card.size = Vector2(420, 440)
	pause_card.custom_minimum_size = Vector2(420, 440)
	pause_overlay.add_child(pause_card)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 14)
	pause_card.add_child(column)
	var title := Label.new()
	title.text = "Tạm dừng"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 30)
	column.add_child(title)
	var resume := _pause_button("Tiếp tục", _close_pause)
	column.add_child(resume)
	var settings := _pause_button("Cài đặt", _open_pause_settings)
	column.add_child(settings)
	var reset := _pause_button("Xóa tiến độ", _confirm_reset)
	column.add_child(reset)
	var menu := _pause_button("Về menu", _go_to_menu)
	column.add_child(menu)
	settings_panel = SettingsPanel.new()
	settings_panel.set_anchors_preset(Control.PRESET_CENTER)
	settings_panel.position = Vector2(-225, -235)
	settings_panel.visible = false
	settings_panel.closed.connect(_close_pause_settings)
	settings_panel.reset_requested.connect(_confirm_reset)
	pause_overlay.add_child(settings_panel)
	reset_dialog = ConfirmationDialog.new()
	reset_dialog.title = "Xóa tiến độ?"
	reset_dialog.dialog_text = "Tiến độ chơi đã lưu sẽ bị xóa. Bạn có muốn tiếp tục không?"
	reset_dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	reset_dialog.confirmed.connect(_reset_progress)
	pause_overlay.add_child(reset_dialog)

func _pause_button(label: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = Vector2(270, 52)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.pressed.connect(action)
	return button

func _open_pause() -> void:
	pause_overlay.visible = true
	pause_card.visible = true
	settings_panel.visible = false
	get_tree().paused = true

func _close_pause() -> void:
	get_tree().paused = false
	pause_overlay.visible = false

func _open_pause_settings() -> void:
	pause_card.visible = false
	settings_panel.visible = true

func _close_pause_settings() -> void:
	settings_panel.visible = false
	pause_card.visible = true

func _confirm_reset() -> void:
	reset_dialog.popup_centered()

func _reset_progress() -> void:
	GameState.reset_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _show_complete() -> void:
	_completion_overlay.visible = true
	get_tree().paused = true

func _build_completion_overlay(root: Control) -> void:
	_completion_overlay = Control.new()
	_completion_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_completion_overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	_completion_overlay.visible = false
	_completion_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_completion_overlay.z_index = 20
	root.add_child(_completion_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0.12, 0.12, 0.12, 0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_completion_overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-210, -130)
	panel.size = Vector2(420, 260)
	panel.custom_minimum_size = Vector2(420, 260)
	_completion_overlay.add_child(panel)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 18)
	panel.add_child(column)
	var title := Label.new()
	title.text = "Tiệm hoa đã gọn gàng! 🌸"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	column.add_child(title)
	var summary := Label.new()
	summary.text = "Bạn đã xếp đủ 30 bông hoa."
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(summary)
	var replay := Button.new()
	replay.text = "Chơi lại"
	replay.custom_minimum_size = Vector2(180, 54)
	replay.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	replay.pressed.connect(_restart_level)
	column.add_child(replay)

func _restart_level() -> void:
	get_tree().paused = false
	GameState.reset_game()
	get_tree().reload_current_scene()

