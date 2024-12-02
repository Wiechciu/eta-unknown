class_name OsTaskbar
extends PanelContainer


signal start_pressed


@export var start: OsStart

func _ready() -> void:
	start.pressed.connect(_on_start_button_pressed)


func _on_start_button_pressed() -> void:
	start_pressed.emit()
