class_name Tooltip
extends Control


@export var header_label: Label
@export var body_label: Label
@export var offset: Vector2 = Vector2(10, 10)


func with_data(header_text: String, body_text: String) -> Tooltip:
	header_label.text = header_text
	body_label.text = body_text
	
	return self


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + offset
