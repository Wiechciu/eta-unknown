class_name ReplyWithTemplateButton
extends Control


signal pressed


func _on_reply_with_template_button_pressed() -> void:
	pressed.emit()
