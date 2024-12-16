class_name SaveNameLineEdit
extends LineEdit


signal text_changed_all(new_text: String)


func _ready() -> void:
	text_changed.connect(text_changed_all.emit)


func change_text(new_text: String) -> void:
	text = new_text
	text_changed_all.emit(text)
