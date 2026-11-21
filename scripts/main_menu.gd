extends Control

const GAME_SCENE := "res://scenes/main.tscn"

var continue_button: Button
var level_picker: OptionButton
var save_error_dialog: AcceptDialog
var settings_panel: SettingsPanel
var reset_dialog: ConfirmationDialog
var new_game_dialog: ConfirmationDialog
var credits_dialog: AcceptDialog
var privacy_dialog: AcceptDialog

func _ready() -> void:
	_build_menu()
	_update_continue_button()

func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color("#e8ddca")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(440, 560)
	center.add_child(card)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 12)
	card.add_child(column)
	var flower_mark := Label.new()
	flower_mark.text = "✿"
	flower_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	flower_mark.add_theme_font_size_override("font_size", 52)
	column.add_child(flower_mark)
	var title := Label.new()
	title.text = "Little Bloom"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	column.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Một tiệm hoa nhỏ đang chờ bạn sắp xếp"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(subtitle)
	level_picker = OptionButton.new()
	level_picker.custom_minimum_size = Vector2(320, 54)
	level_picker.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	for level_id in LevelConfig.PROFILES:
		level_picker.add_item(str(LevelConfig.PROFILES[level_id].label))
		var index := level_picker.item_count - 1
		level_picker.set_item_metadata(index, level_id)
		if level_id == GameState.level_id():
			level_picker.select(index)
	level_picker.item_selected.connect(_select_level)
	column.add_child(level_picker)
	var new_game := Button.new()
	new_game.text = "Chơi mới"
	new_game.custom_minimum_size = Vector2(270, 56)
	new_game.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	new_game.pressed.connect(_start_new_game)
	column.add_child(new_game)
	continue_button = Button.new()
	continue_button.text = "Tiếp tục"
	continue_button.custom_minimum_size = Vector2(270, 56)
	continue_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	continue_button.pressed.connect(_continue_game)
	column.add_child(continue_button)
	var settings := Button.new()
	settings.text = "Cài đặt"
	settings.custom_minimum_size = Vector2(270, 50)
	settings.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	settings.pressed.connect(_open_settings)
	column.add_child(settings)
	var credits := Button.new()
	credits.text = "Credits & giấy phép"
	credits.custom_minimum_size = Vector2(270, 50)
	credits.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	credits.pressed.connect(_open_credits)
	column.add_child(credits)
	var privacy := Button.new()
	privacy.text = "Quyền riêng tư"
	privacy.custom_minimum_size = Vector2(270, 50)
	privacy.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	privacy.pressed.connect(_open_privacy_policy)
	column.add_child(privacy)
	settings_panel = SettingsPanel.new()
	settings_panel.set_anchors_preset(Control.PRESET_CENTER)
	settings_panel.position = Vector2(-225, -235)
	settings_panel.visible = false
	settings_panel.closed.connect(func(): settings_panel.visible = false)
	settings_panel.reset_requested.connect(_confirm_reset)
	add_child(settings_panel)
	reset_dialog = _make_reset_dialog()
	add_child(reset_dialog)
	new_game_dialog = ConfirmationDialog.new()
	new_game_dialog.title = "Bắt đầu lượt mới?"
	new_game_dialog.confirmed.connect(_begin_new_game)
	add_child(new_game_dialog)
	save_error_dialog = AcceptDialog.new()
	save_error_dialog.title = "Không lưu được tiến độ"
	save_error_dialog.dialog_text = "Hãy kiểm tra dung lượng thiết bị rồi thử lại."
	add_child(save_error_dialog)
	credits_dialog = AcceptDialog.new()
	credits_dialog.title = "Credits & giấy phép"
	credits_dialog.dialog_text = _load_credits()
	add_child(credits_dialog)
	privacy_dialog = AcceptDialog.new()
	privacy_dialog.title = "Chính sách quyền riêng tư"
	privacy_dialog.dialog_text = _load_privacy_policy()
	add_child(privacy_dialog)

func _update_continue_button() -> void:
	continue_button.visible = GameState.has_progress()

func _select_level(index: int) -> void:
	if not GameState.choose_level(str(level_picker.get_item_metadata(index))):
		for i in level_picker.item_count:
			if level_picker.get_item_metadata(i) == GameState.level_id():
				level_picker.select(i)
				break
		save_error_dialog.popup_centered()
	_update_continue_button()

func _start_new_game() -> void:
	if GameState.has_save_files():
		new_game_dialog.dialog_text = "Bắt đầu lại chế độ %s sẽ xóa tiến độ đã lưu của chế độ này." % GameState.level_profile().label
		new_game_dialog.popup_centered()
		return
	_begin_new_game()

func _begin_new_game() -> void:
	if not GameState.reset_game():
		save_error_dialog.popup_centered()
		return
	get_tree().change_scene_to_file(GAME_SCENE)

func _continue_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _open_settings() -> void:
	settings_panel.visible = true

func _confirm_reset() -> void:
	reset_dialog.dialog_text = "Xóa tiến độ đã lưu của chế độ %s?" % GameState.level_profile().label
	reset_dialog.popup_centered()

func _make_reset_dialog() -> ConfirmationDialog:
	var dialog := ConfirmationDialog.new()
	dialog.title = "Xóa tiến độ?"
	dialog.confirmed.connect(_reset_progress)
	return dialog

func _reset_progress() -> void:
	if not GameState.reset_game():
		save_error_dialog.popup_centered()
	_update_continue_button()

func _open_credits() -> void:
	credits_dialog.popup_centered(Vector2i(760, 580))

func _open_privacy_policy() -> void:
	privacy_dialog.popup_centered(Vector2i(760, 580))

func _load_privacy_policy() -> String:
	var policy := FileAccess.open("res://PRIVACY_POLICY.md", FileAccess.READ)
	if policy == null:
		return "Chưa tải được chính sách quyền riêng tư."
	return policy.get_as_text()

func _load_credits() -> String:
	var credits := "Little Bloom\n\n"
	var license_file := FileAccess.open("res://licenses/GODOT_MIT.txt", FileAccess.READ)
	if license_file != null:
		credits += license_file.get_as_text()
	return credits
