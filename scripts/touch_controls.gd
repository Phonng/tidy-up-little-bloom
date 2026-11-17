extends CanvasLayer
class_name TouchControls

signal move_changed(value: Vector2)
signal look_changed(delta: Vector2)
signal interact_requested

var prompt_label: Label
var progress_label: Label
var inventory_label: Label
var notice_label: Label
var joystick_base: ColorRect
var joystick_knob: ColorRect
var _move_touch := -1
var _look_touch := -1
var _move_origin := Vector2.ZERO
var _move_value := Vector2.ZERO
var _interact_rect := Rect2()
var _pause_rect := Rect2()

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	GameState.changed.connect(_refresh)
	GameState.notice.connect(_show_notice)
	GameState.completed.connect(_show_complete)
	_refresh()

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
	inventory_label.position = Vector2(28, 60)
	root.add_child(inventory_label)
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
		var carried := " · ".join(GameState.inventory.map(func(id: String): return GameState.type_name(GameState.flower_type_from_id(id))))
		inventory_label.text = "Đang cầm %d/%d: %s" % [GameState.inventory.size(), GameState.MAX_CARRY, carried]

func _show_notice(message: String) -> void:
	if not is_instance_valid(notice_label):
		return
	notice_label.text = message
	await get_tree().create_timer(1.4).timeout
	if is_instance_valid(notice_label) and notice_label.text == message:
		notice_label.text = ""

func _toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		_show_notice("Đã tạm dừng — chạm Ⅱ để tiếp tục")

func _show_complete() -> void:
	_show_notice("Tiệm hoa đã gọn gàng! 🌸")

