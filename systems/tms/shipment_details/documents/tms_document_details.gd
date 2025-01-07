class_name TmsDocumentDetails
extends Node


var document: Document
@export var document_check_box: CheckBox
@export var label_check_box: CheckBox
@export var code_label: Label
@export var name_label: Label
@export var number_label: Label
@export var time_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(document: Document) -> TmsDocumentDetails:
	self.document = document
	code_label.text = document.code_string
	name_label.text = document.name
	number_label.text = str(document.number)
	time_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(document.issued_time)
	
	label_check_box.disabled = not Document.DOCUMENTS_WITH_LABELS.has(document.code)
	
	return self
