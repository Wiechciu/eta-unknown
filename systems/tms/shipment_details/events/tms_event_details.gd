class_name TmsEventDetails
extends Node


@export var _code: Label
@export var _name: Label
@export var _time: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(event: Event) -> TmsEventDetails:
	_code.text = event.code_string
	_name.text = event.name
	_time.text = GlobalTimer.get_nice_datetime_string_from_event(event)
	
	return self
