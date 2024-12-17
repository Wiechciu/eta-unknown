class_name Ui
extends Control


@export var toggleable_panels_container: Control
@export var main_menu: Control
var is_main_menu_open: bool:
	get:
		for child: Node in toggleable_panels_container.get_children():
			if child == main_menu and (child as Control).visible:
				return true
		return false
var old_input_mouse_mode: Input.MouseMode


func _ready() -> void:
	SaveManager.game_loaded.connect(toggle_visibility)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	show_ui()


func _on_play_button_pressed() -> void:
	toggle_visibility()


func _unhandled_input(event: InputEvent) -> void:
	handle_escape_button(event)


func handle_escape_button(event: InputEvent) -> void:
	if not event.is_action_pressed("cancel"):
		return
	
	if not is_main_menu_open:
		bring_main_menu_to_front()
		return
	
	if not SaveManager.is_game_loaded:
		return
	
	toggle_visibility()


func toggle_visibility() -> void:
	if not visible:
		show_ui()
	else:
		hide_ui()


func show_ui() -> void:
	bring_main_menu_to_front()
	get_tree().paused = true
	old_input_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func hide_ui() -> void:
	get_tree().paused = false
	Input.mouse_mode = old_input_mouse_mode
	hide()


func bring_main_menu_to_front() -> void:
	for child: Node in toggleable_panels_container.get_children():
		if child == main_menu:
			(child as Control).show()
		else:
			(child as Control).hide()
