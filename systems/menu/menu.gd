class_name Menu
extends Control


var is_player_menu_open: bool:
	get:
		return player_menu_container.visible

@export var player_hud_container: Control
@export var player_menu_container: Control
@export var states: PlayerMenuStates
@export var states_hud_parent: Control
@export var states_player_menu_parent: Control


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	fold_all_except_first()
	close_player_menu()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if is_player_menu_open:
			close_player_menu()
		else:
			open_player_menu()


func fold_all_except_first() -> void:
	for child: Node in player_menu_container.get_children():
		if child == player_menu_container.get_child(0):
			(child as FoldableContainer).expand()
		else:
			(child as FoldableContainer).fold()


func open_player_menu() -> void:
	states.show()
	states.reparent(states_player_menu_parent)
	states.show_state_names()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	player_hud_container.hide()
	player_menu_container.show()


func close_player_menu() -> void:
	states.show()
	states.reparent(states_hud_parent)
	states.hide_state_names()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	player_hud_container.show()
	player_menu_container.hide()


func show_player_hud() -> void:
	if not is_player_menu_open:
		player_hud_container.show()


func hide_player_hud() -> void:
	player_hud_container.hide()
