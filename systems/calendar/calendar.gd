extends PanelContainer


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_console"):
		visible = not visible
