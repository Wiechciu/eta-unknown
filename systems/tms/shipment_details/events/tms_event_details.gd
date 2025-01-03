class_name TmsEventDetails
extends Node


var event: Event
@export var code_label: Label
@export var name_label: Label
@export var time_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(event: Event) -> TmsEventDetails:
	self.event = event
	code_label.text = event.code_string
	name_label.text = event.name
	time_label.text = GlobalTimer.get_nice_datetime_string_from_event(event)
	
	return self
