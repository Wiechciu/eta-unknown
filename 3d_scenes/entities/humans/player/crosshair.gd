extends TextureRect


func _process(delta: float) -> void:
	visible = Input.mouse_mode != Input.MOUSE_MODE_VISIBLE
