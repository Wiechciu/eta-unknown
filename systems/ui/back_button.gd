extends Button


@export var control_to_hide: Control


func _on_pressed() -> void:
	control_to_hide.hide()
