extends PanelContainer
class_name SettingsPanel

signal closed
signal reset_requested

func _ready() -> void:
	custom_minimum_size = Vector2(450, 470)
	process_mode = Node.PROCESS_MODE_ALWAYS
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	add_child(column)
	var title := Label.new()
	title.text = "Cài đặt"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	column.add_child(title)
	_add_slider(column, "Độ nhạy nhìn", SettingsManager.look_sensitivity, 0.5, 2.0, 0.05, SettingsManager.set_look_sensitivity)
	var invert := CheckButton.new()
	invert.text = "Đảo trục nhìn dọc"
	invert.button_pressed = SettingsManager.invert_y
	invert.toggled.connect(SettingsManager.set_invert_y)
	column.add_child(invert)
	_add_slider(column, "Âm lượng nhạc", SettingsManager.music_volume, 0.0, 1.0, 0.05, SettingsManager.set_music_volume)
	_add_slider(column, "Âm lượng hiệu ứng", SettingsManager.sfx_volume, 0.0, 1.0, 0.05, SettingsManager.set_sfx_volume)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(spacer)
	var reset := Button.new()
	reset.text = "Xóa tiến độ đã lưu"
	reset.custom_minimum_size.y = 48
	reset.pressed.connect(func(): reset_requested.emit())
	column.add_child(reset)
	var close_button := Button.new()
	close_button.text = "Đóng"
	close_button.custom_minimum_size.y = 48
	close_button.pressed.connect(func(): closed.emit())
	column.add_child(close_button)

func _add_slider(parent: VBoxContainer, label_text: String, initial_value: float, minimum: float, maximum: float, step: float, on_change: Callable) -> void:
	var title := Label.new()
	title.text = label_text
	parent.add_child(title)
	var slider := HSlider.new()
	slider.min_value = minimum
	slider.max_value = maximum
	slider.step = step
	slider.value = initial_value
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(on_change)
	parent.add_child(slider)
