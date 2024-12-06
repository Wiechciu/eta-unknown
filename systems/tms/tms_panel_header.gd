class_name TmsPanelHeader
extends Control


signal minimize_button_pressed
signal close_button_pressed


@export var _control_to_move: Control
var is_moving: bool


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func _on_gui_input(event: InputEvent) -> void:
	print(_control_to_move.name)
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			_control_to_move.move_to_front()
			is_moving = true
		else:
			is_moving = false
	elif event is InputEventMouseMotion and is_moving:
		_control_to_move.global_position = _control_to_move.global_position + (event as InputEventMouseMotion).relative


func _on_close_button_pressed() -> void:
	close_button_pressed.emit()


func _on_minimize_button_pressed() -> void:
	minimize_button_pressed.emit()
