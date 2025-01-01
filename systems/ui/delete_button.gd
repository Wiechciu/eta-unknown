extends Button


@export var save_name_line_edit: SaveNameLineEdit


func _ready() -> void:
	save_name_line_edit.text_changed_all.connect(_on_line_edit_text_changed)
	_on_line_edit_text_changed(save_name_line_edit.text)


func _on_line_edit_text_changed(new_text: String) -> void:
	disabled = not SaveManager.save_file_exists(new_text)


func _on_pressed() -> void:
	SaveManager.delete_save_file(save_name_line_edit.text)
