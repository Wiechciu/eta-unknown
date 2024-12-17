extends PanelContainer


@export var container: Control
@export var list_item_scene: PackedScene


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	clear_container()
	populate_container()


func clear_container() -> void:
	for child: Node in container.get_children():
		child.queue_free()


func populate_container() -> void:
	for action_string: String in InputMap.get_actions():
		if action_string.begins_with("ui"):
			continue
		
		for event: InputEvent in InputMap.action_get_events(action_string):
			var event_string: String
			#if event is InputEventKey:
				#event_string = OS.get_keycode_string(event.get_physical_keycode_with_modifiers())
			#else:
			event_string = event.as_text()
			var list_item: ControlsListItem = (list_item_scene.instantiate() as ControlsListItem).with_data(action_string, event_string)
			container.add_child(list_item)
