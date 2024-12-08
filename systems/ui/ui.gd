class_name Ui
extends Control


var old_input_mouse_mode: Input.MouseMode


func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_visibility()


func toggle_visibility() -> void:
	if not visible:
		Engine.time_scale = 0
		old_input_mouse_mode = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
	else:
		Engine.time_scale = 1
		Input.mouse_mode = old_input_mouse_mode
		hide()


func _on_play_button_pressed() -> void:
	toggle_visibility()
