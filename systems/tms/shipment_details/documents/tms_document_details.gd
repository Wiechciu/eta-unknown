class_name TmsDocumentDetails
extends Node


@export var _code: Label
@export var _name: Label
@export var _number: Label
@export var _time: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(document: Document) -> TmsDocumentDetails:
	_code.text = document.code_string
	_name.text = document.name
	_number.text = str(document.number)
	_time.text = GlobalTimer.get_nice_datetime_string_from_unix_time(document.issued_time)
	
	return self
