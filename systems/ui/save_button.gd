extends Button


@export var save_name_line_edit: SaveNameLineEdit


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if SaveManager.is_game_loaded:
		disabled = false
	else:
		disabled = true


func _on_pressed() -> void:
	if not SaveManager.is_saving_game:
		SaveManager.save_game(save_name_line_edit.text)
