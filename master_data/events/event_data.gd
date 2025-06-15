class_name EventData
extends Resource


@export var code: String
@export var name: String
@export var description: String


@warning_ignore("shadowed_variable")
static func get_event_by_code(code: String) -> EventData:
	for event: EventData in GlobalRefs.events:
		if event.code == code:
			return event
	
	printerr("Could't find event code: " + code)
	return null
