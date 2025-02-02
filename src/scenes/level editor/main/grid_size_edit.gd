extends LineEdit

func _on_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int(): 
		LevelEditGlobal.update_grid_size(int(new_text))
	else: 
		add_theme_color_override("font_color", Color(1, 0, 0))


func _on_text_changed(new_text: String) -> void:
	add_theme_color_override("font_color", Color(1, 1, 1))
