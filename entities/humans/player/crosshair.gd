extends Control


@export var interactable_finder: InteractableFinder
@export var regular_crosshair: TextureRect
@export var interactable_crosshair: TextureRect

var tween_in: Tween
var tween_out: Tween


func _ready() -> void:
	regular_crosshair.show()
	interactable_crosshair.hide()
	interactable_crosshair.scale = Vector2(0, 1)
	interactable_finder.on_hover_started.connect(interactable_on_hover_started)
	interactable_finder.on_hover_ended.connect(interactable_on_hover_ended)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	visible = Input.mouse_mode != Input.MOUSE_MODE_VISIBLE


func interactable_on_hover_started() -> void:
	if tween_out != null and tween_out.is_running():
		tween_out.stop()
	
	tween_in = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_in.tween_callback(interactable_crosshair.show)
	tween_in.chain().tween_property(interactable_crosshair, "scale", Vector2.ONE, 1.0)


func interactable_on_hover_ended() -> void:
	if tween_in != null and tween_in.is_running():
		tween_in.stop()
	
	tween_out = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween_out.tween_property(interactable_crosshair, "scale", Vector2(0, 1), 0.2)
	tween_out.chain().tween_callback(interactable_crosshair.hide)
