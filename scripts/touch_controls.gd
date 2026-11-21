extends CanvasLayer
class_name TouchControls

const SFX_PICKUP: AudioStream = preload("res://assets/audio/pickup.wav")
const SFX_PLACE: AudioStream = preload("res://assets/audio/place.wav")
const SFX_REJECT: AudioStream = preload("res://assets/audio/reject.wav")
const SFX_COMPLETE: AudioStream = preload("res://assets/audio/complete.wav")

signal move_changed(value: Vector2)
signal look_changed(delta: Vector2)
signal interact_requested
signal input_cleared

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
var tutorial_overlay: Control
var tutorial_title: Label
var tutorial_body: Label
var tutorial_next: Button
var tutorial_step := 0
var _move_touch := -1
var _look_touch := -1
var _move_origin := Vector2.ZERO
var _move_value := Vector2.ZERO
var _interact_hud_button: Button
var _pause_hud_button: Button
var _interact_touch := -1
var _pause_touch := -1
var _completion_overlay: Control
var _sfx_player: AudioStreamPlayer
var _fps_label: Label
var _fps_sample_elapsed := 0.0
var _fps_sample_index := 0
var _foreground := true
var _starter_panel: PanelContainer
var _starter_hint: Label
var _starter_finished := false

func _ready() -> void:
	layer = 10
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	set_process(is_instance_valid(_fps_label))
	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)
	GameState.changed.connect(_refresh)
	GameState.notice.connect(_show_notice)
	GameState.picked_up.connect(_play_pickup_sfx)
	GameState.placement_rejected.connect(_play_reject_sfx)
	GameState.placed_correctly.connect(_play_place_sfx)
	GameState.completed.connect(_show_complete)
	_refresh()
	if GameState.is_complete():
		_show_complete()
	elif GameState.level_id() == LevelConfig.STRESS and not SettingsManager.tutorial_seen:
		_show_tutorial()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_RESUMED:
		_foreground = true
	elif what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		_foreground = false
		_fps_sample_elapsed = 0.0
		_clear_touch_input()

func _process(delta: float) -> void:
	if not _foreground or get_tree().paused:
		_fps_sample_elapsed = 0.0
		return
	_fps_sample_elapsed += delta
	if _fps_sample_elapsed < 1.0:
		return
	_fps_sample_elapsed = 0.0
	_fps_sample_index += 1
	var fps := Engine.get_frames_per_second()
	_fps_label.text = "FPS %d" % fps
	print("LB_QA_FPS level=%s sample=%d fps=%d" % [GameState.level_id(), _fps_sample_index, fps])

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
	inventory_label.position = Vector2(28, 124)
	root.add_child(inventory_label)
	if OS.has_feature("android_qa"):
		_fps_label = Label.new()
		_fps_label.text = "FPS …"
		_fps_label.position = Vector2(28, 151)
		_fps_label.add_theme_constant_override("outline_size", 5)
		_fps_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(_fps_label)
	detail_label = Label.new()
	detail_label.add_theme_font_size_override("font_size", 13)
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
	_interact_hud_button = interact_button
	var pause_button := Button.new()
	pause_button.text = "Ⅱ"
	pause_button.custom_minimum_size = Vector2(64, 58)
	pause_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	pause_button.position = Vector2(-82, 20)
	pause_button.pressed.connect(_toggle_pause)
	root.add_child(pause_button)
	_pause_hud_button = pause_button
	if OS.has_feature("mobile"):
		# Gameplay taps are routed by finger ID, independently of mouse emulation.
		_interact_hud_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_pause_hud_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if GameState.level_id() == LevelConfig.DEMO:
		_build_starter_hint(root)
	_build_pause_overlay(root)
	_build_tutorial_overlay(root)
	_build_completion_overlay(root)

func _input(event: InputEvent) -> void:
	if _has_modal_overlay():
		return
	if event is InputEventScreenTouch:
		_handle_screen_touch(event)
	elif event is InputEventScreenDrag:
		if event.index == _move_touch:
			_move_value = ((event.position - _move_origin) / 90.0).limit_length(1.0)
			joystick_knob.position = _move_origin + _move_value * 40.0 - joystick_knob.size / 2.0
			move_changed.emit(_move_value)
		elif event.index == _look_touch:
			look_changed.emit(event.relative)

func _handle_screen_touch(event: InputEventScreenTouch) -> void:
	var on_interact := _interact_hud_button.get_global_rect().has_point(event.position)
	var on_pause := _pause_hud_button.get_global_rect().has_point(event.position)
	if event.pressed and not event.canceled:
		if on_interact:
			if _interact_touch == -1:
				_interact_touch = event.index
		elif on_pause:
			if _pause_touch == -1:
				_pause_touch = event.index
		elif event.position.x < get_viewport().get_visible_rect().size.x * 0.42:
			if _move_touch == -1:
				_move_touch = event.index
				_move_origin = event.position
				_move_value = Vector2.ZERO
				joystick_base.position = _move_origin - joystick_base.size / 2.0
				joystick_knob.position = _move_origin - joystick_knob.size / 2.0
				joystick_base.visible = true
				joystick_knob.visible = true
				move_changed.emit(_move_value)
		elif _look_touch == -1:
			_look_touch = event.index
		return
	if event.index == _interact_touch:
		_interact_touch = -1
		if on_interact and not event.canceled:
			interact_requested.emit()
	elif event.index == _pause_touch:
		_pause_touch = -1
		if on_pause and not event.canceled:
			_open_pause()
	elif event.index == _move_touch:
		_move_touch = -1
		_move_value = Vector2.ZERO
		joystick_base.hide()
		joystick_knob.hide()
		move_changed.emit(_move_value)
	elif event.index == _look_touch:
		_look_touch = -1

func set_prompt(value: String) -> void:
	if is_instance_valid(prompt_label):
		prompt_label.text = value

func _refresh() -> void:
	if is_instance_valid(progress_label):
		progress_label.text = GameState.progress_text()
		var totals: Array[String] = []
		for flower_type in GameState.FLOWER_TYPES:
			totals.append("%s %d/%d" % [GameState.type_name(flower_type), GameState.placed_count(flower_type), GameState.flower_target(flower_type)])
		var total_lines: Array[String] = []
		for row in 3:
			var row_totals: Array[String] = []
			for column in 3:
				var index := row * 3 + column
				if index < totals.size():
					row_totals.append(totals[index])
			total_lines.append("   ·   ".join(PackedStringArray(row_totals)))
		detail_label.text = "\n".join(PackedStringArray(total_lines))
		var carried_counts: Dictionary = {}
		for flower_id in GameState.inventory:
			var flower_type := GameState.flower_type_from_id(flower_id)
			carried_counts[flower_type] = int(carried_counts.get(flower_type, 0)) + 1
		var carried: Array[String] = []
		for flower_type in GameState.FLOWER_TYPES:
			if carried_counts.has(flower_type):
				carried.append("%s ×%d" % [GameState.type_name(flower_type), carried_counts[flower_type]])
		inventory_label.text = "Đang cầm %d/%d: %s" % [GameState.inventory.size(), GameState.MAX_CARRY, " · ".join(PackedStringArray(carried))]
		if is_instance_valid(_starter_panel):
			_refresh_starter_hint(int(carried_counts.get("rose", 0)))

func _build_starter_hint(root: Control) -> void:
	_starter_finished = GameState.placed_count("rose") >= GameState.flower_target("rose")
	_starter_panel = PanelContainer.new()
	_starter_panel.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_starter_panel.position = Vector2(-266, 150)
	_starter_panel.custom_minimum_size = Vector2(532, 74)
	_starter_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_starter_panel.visible = not _starter_finished
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#352924e8")
	style.set_corner_radius_all(10)
	style.content_margin_left = 14.0
	style.content_margin_right = 14.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	_starter_panel.add_theme_stylebox_override("panel", style)
	root.add_child(_starter_panel)
	_starter_hint = Label.new()
	_starter_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_starter_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_starter_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_starter_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_starter_hint.add_theme_font_size_override("font_size", 17)
	_starter_panel.add_child(_starter_hint)

func _refresh_starter_hint(rose_carried: int) -> void:
	if _starter_finished:
		return
	var target := GameState.flower_target("rose")
	var placed := GameState.placed_count("rose")
	if placed == target:
		_starter_finished = true
		_starter_hint.text = "Xong giỏ hồng · %d/%d\nBạn có thể dạo tiệm và xếp các loại hoa còn lại." % [placed, target]
		await get_tree().create_timer(4.0, false).timeout
		_starter_panel.hide()
		return
	var action := "NHẶT / ĐẶT" if OS.has_feature("mobile") else "E"
	var hint: String
	if rose_carried > 0 and (GameState.inventory.size() == GameState.MAX_CARRY or placed + rose_carried == target):
		hint = "Ngắm giỏ hoa hồng. Nhấn %s một lần cho mỗi bông." % action
	elif GameState.inventory.size() == GameState.MAX_CARRY:
		hint = "Tay đã đầy. Đặt hoa đang cầm vào giỏ đúng loại để lấy chỗ."
	elif rose_carried > 0:
		hint = "Đang cầm %d bông hồng. Nhặt thêm hoặc mang đến giỏ." % rose_carried
	elif OS.has_feature("mobile"):
		hint = "Kéo bên trái để đi, vuốt bên phải để ngắm hoa hồng. Bấm %s." % action
	else:
		hint = "WASD để đi. Bấm vào cửa sổ, dùng chuột ngắm hoa hồng rồi nhấn E."
	_starter_hint.text = "Giỏ đầu tiên · Hoa hồng %d/%d\n%s" % [placed, target, hint]

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
	reset_dialog.dialog_text = "Xóa tiến độ đã lưu của chế độ %s?" % GameState.level_profile().label
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
	_clear_touch_input()
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
	if not GameState.reset_game():
		return
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _build_tutorial_overlay(root: Control) -> void:
	tutorial_overlay = Control.new()
	tutorial_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tutorial_overlay.process_mode = Node.PROCESS_MODE_ALWAYS
	tutorial_overlay.visible = false
	tutorial_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_overlay.z_index = 15
	root.add_child(tutorial_overlay)
	var dim := ColorRect.new()
	dim.color = Color(0.12, 0.12, 0.12, 0.68)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	tutorial_overlay.add_child(dim)
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-230, -165)
	panel.size = Vector2(460, 330)
	panel.custom_minimum_size = Vector2(460, 330)
	tutorial_overlay.add_child(panel)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 18)
	panel.add_child(column)
	tutorial_title = Label.new()
	tutorial_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tutorial_title.add_theme_font_size_override("font_size", 28)
	column.add_child(tutorial_title)
	tutorial_body = Label.new()
	tutorial_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tutorial_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_body.custom_minimum_size.x = 390
	column.add_child(tutorial_body)
	tutorial_next = Button.new()
	tutorial_next.custom_minimum_size = Vector2(200, 54)
	tutorial_next.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	tutorial_next.pressed.connect(_advance_tutorial)
	column.add_child(tutorial_next)
	var skip := Button.new()
	skip.text = "Bỏ qua hướng dẫn"
	skip.flat = true
	skip.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	skip.pressed.connect(_finish_tutorial)
	column.add_child(skip)

func _show_tutorial() -> void:
	_clear_touch_input()
	tutorial_step = 0
	_update_tutorial_page()
	tutorial_overlay.visible = true
	get_tree().paused = true

func _update_tutorial_page() -> void:
	var pages := [
		["Di chuyển", "Dùng joystick bên trái để đi quanh tiệm và lên dốc tới tầng lửng. Trên máy tính, dùng WASD hoặc phím mũi tên."],
		["Quan sát", "Vuốt vùng bên phải để nhìn quanh. Trên máy tính, nhấn vào game rồi di chuyển chuột."],
		["Nhặt và xếp hoa", "Ngắm một bông rồi nhấn NHẶT / ĐẶT. Mang tối đa 5 bông và đặt vào giỏ có đúng loại hoa."],
	]
	tutorial_title.text = "Hướng dẫn %d/3 · %s" % [tutorial_step + 1, pages[tutorial_step][0]]
	tutorial_body.text = pages[tutorial_step][1]
	tutorial_next.text = "Bắt đầu" if tutorial_step == 2 else "Tiếp tục"

func _advance_tutorial() -> void:
	if tutorial_step < 2:
		tutorial_step += 1
		_update_tutorial_page()
	else:
		_finish_tutorial()

func _finish_tutorial() -> void:
	SettingsManager.mark_tutorial_seen()
	tutorial_overlay.visible = false
	get_tree().paused = false

func _show_complete() -> void:
	_clear_touch_input()
	_play_sfx(SFX_COMPLETE)
	_completion_overlay.visible = true
	get_tree().paused = true

func _play_pickup_sfx() -> void:
	_play_sfx(SFX_PICKUP)

func _play_place_sfx() -> void:
	if not GameState.is_complete():
		_play_sfx(SFX_PLACE)

func _play_reject_sfx() -> void:
	_play_sfx(SFX_REJECT)

func _play_sfx(stream: AudioStream) -> void:
	_sfx_player.stream = stream
	_sfx_player.play()

func _has_modal_overlay() -> bool:
	return (is_instance_valid(pause_overlay) and pause_overlay.visible) \
		or (is_instance_valid(tutorial_overlay) and tutorial_overlay.visible) \
		or (is_instance_valid(_completion_overlay) and _completion_overlay.visible)

func _clear_touch_input() -> void:
	_move_touch = -1
	_look_touch = -1
	_interact_touch = -1
	_pause_touch = -1
	_move_value = Vector2.ZERO
	if is_instance_valid(joystick_base):
		joystick_base.visible = false
	if is_instance_valid(joystick_knob):
		joystick_knob.visible = false
	move_changed.emit(Vector2.ZERO)
	input_cleared.emit()

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
	summary.text = "Bạn đã xếp đủ %d bông hoa." % GameState.total_flowers()
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(summary)
	var replay := Button.new()
	replay.text = "Chơi lại"
	replay.custom_minimum_size = Vector2(180, 54)
	replay.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	replay.pressed.connect(_restart_level)
	column.add_child(replay)

func _restart_level() -> void:
	if not GameState.reset_game():
		return
	get_tree().paused = false
	get_tree().reload_current_scene()

