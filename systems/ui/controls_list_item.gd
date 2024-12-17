class_name ControlsListItem
extends HBoxContainer


@export var action_label: Label
@export var event_button: Button


func with_data(action: String, event: String) -> ControlsListItem:
	action_label.text = "ACTION_%s" % action.to_upper()
	event_button.text = event.replace(" (Physical)", "")
	
	return self
