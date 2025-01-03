class_name ControlsListItem
extends HBoxContainer


@export var action_label: Label
@export var event_buttons: Array[ActionEventButton]

var action_name: String

var is_listening: bool = false


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(action_name: String) -> ControlsListItem:
	self.action_name = action_name
	action_label.text = "ACTION_%s" % action_name.to_upper()
	
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	var counter: int = 0
	for event_button: ActionEventButton in event_buttons:
		event_button.with_data(action_name, events[counter] as InputEventKey if (events.size() > counter) else null)
		counter += 1
	
	return self
