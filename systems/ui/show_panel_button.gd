extends Button


@export var control_to_show: Control


func _on_pressed() -> void:
	control_to_show.show()
