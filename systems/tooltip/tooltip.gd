class_name Tooltip
extends Control


@export var icon_rect: TextureRect
@export var header_label: Label
@export var body_label: Label
@export var offset: Vector2 = Vector2(10, 10)


func with_data(icon_texture: Texture2D, header_text: String, body_text: String) -> Tooltip:
	icon_rect.texture = icon_texture
	header_label.text = header_text
	body_label.text = body_text
	
	return self


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + offset
	
	if global_position.x + size.x > get_window().size.x:
		global_position.x -= (2 * offset.x + size.x)
	if global_position.y + size.y > get_window().size.y:
		global_position.y -= (2 * offset.y + size.y)
