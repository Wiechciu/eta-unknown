extends PanelContainer


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_console"):
		
		visible = not visible
