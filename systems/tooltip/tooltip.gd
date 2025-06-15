class_name Tooltip
extends Control


@export var header_container: Container
@export var icon_rect: TextureRect
@export var header_label: Label
@export var body_label: Label
@export var offset: Vector2 = Vector2(10, 10)
@export var fade_in_duration: float = 0.2
@export var fade_out_duration: float = 0.2


func initialize(icon_texture: Texture2D, header_text: String, body_text: String) -> Tooltip:
	if header_text == "":
		header_container.hide()
	else:
		header_label.text = header_text
		if icon_texture != null:
			icon_rect.texture = icon_texture
		else:
			icon_rect.hide()
	
	self.body_label.text = body_text
	
	return self


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + offset
	
	if global_position.x + size.x > get_window().size.x:
		global_position.x -= (2 * offset.x + size.x)
	if global_position.y + size.y > get_window().size.y:
		global_position.y -= (2 * offset.y + size.y)


func fade_in() -> void:
	modulate.a = 0
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_in_duration)


func fade_out() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(self, "modulate:a", 0.0, fade_out_duration)
	tween.tween_callback(queue_free)
