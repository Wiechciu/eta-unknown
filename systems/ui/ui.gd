class_name Ui
extends Control


var old_input_mouse_mode: Input.MouseMode
@export var main_menu: Control


func _ready() -> void:
	SaveManager.game_loaded.connect(toggle_visibility)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	show_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and SaveManager.is_game_loaded:
		toggle_visibility()


func toggle_visibility() -> void:
	if not visible:
		show_ui()
	else:
		hide_ui()


func _on_play_button_pressed() -> void:
	toggle_visibility()


func show_ui() -> void:
	for child: Node in get_children():
		if child == main_menu:
			(child as Control).show()
		else:
			(child as Control).hide()
	get_tree().paused = true
	old_input_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func hide_ui() -> void:
	get_tree().paused = false
	Input.mouse_mode = old_input_mouse_mode
	hide()
