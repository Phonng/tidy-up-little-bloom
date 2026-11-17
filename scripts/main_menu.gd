extends Control

const GAME_SCENE := "res://scenes/main.tscn"

var continue_button: Button
var settings_panel: SettingsPanel
var reset_dialog: ConfirmationDialog
var new_game_dialog: ConfirmationDialog

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
	card.custom_minimum_size = Vector2(440, 500)
	center.add_child(card)
	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 16)
	card.add_child(column)
	var flower_mark := Label.new()
	flower_mark.text = "✿"
	flower_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	flower_mark.add_theme_font_size_override("font_size", 68)
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
	new_game_dialog.dialog_text = "Tiến độ hiện tại sẽ bị xóa. Bạn có muốn bắt đầu lại không?"
	new_game_dialog.confirmed.connect(_begin_new_game)
	add_child(new_game_dialog)

func _update_continue_button() -> void:
	continue_button.visible = GameState.has_progress()

func _start_new_game() -> void:
	if GameState.has_progress():
		new_game_dialog.popup_centered()
		return
	_begin_new_game()

func _begin_new_game() -> void:
	GameState.reset_game()
	get_tree().change_scene_to_file(GAME_SCENE)

func _continue_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _open_settings() -> void:
	settings_panel.visible = true

func _confirm_reset() -> void:
	reset_dialog.popup_centered()

func _make_reset_dialog() -> ConfirmationDialog:
	var dialog := ConfirmationDialog.new()
	dialog.title = "Xóa tiến độ?"
	dialog.dialog_text = "Tiến độ chơi đã lưu sẽ bị xóa. Bạn có muốn tiếp tục không?"
	dialog.confirmed.connect(_reset_progress)
	return dialog

func _reset_progress() -> void:
	GameState.reset_game()
	_update_continue_button()
