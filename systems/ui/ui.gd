class_name Ui
extends Control


var old_input_mouse_mode: Input.MouseMode


func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_visibility()


func toggle_visibility() -> void:
	if visible:
		Input.mouse_mode = old_input_mouse_mode
		hide()
	else:
		old_input_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
