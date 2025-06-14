extends Button


func _on_pressed() -> void:
	if not SaveManager.is_loading_game:
		SaveManager.start_new_game()
