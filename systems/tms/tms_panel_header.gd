class_name TmsPanelHeader
extends Control


@export var control_to_move: Control
var is_moving: bool


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			control_to_move.move_to_front()
			is_moving = true
		else:
			is_moving = false
	elif event is InputEventMouseMotion and is_moving:
		control_to_move.global_position = control_to_move.global_position + (event as InputEventMouseMotion).relative
