class_name TmsDocumentDetails
extends Node


var document: Document
@export var document_check_box: Button
@export var label_check_box: Button
@export var code_label: Label
@export var name_label: Label
@export var number_label: Label
@export var time_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func initialize(document: Document) -> TmsDocumentDetails:
	self.document = document
	self.code_label.text = document.document_data.code
	self.name_label.text = document.document_data.name
	self.number_label.text = str(document.number)
	self.time_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(document.issued_time)
	
	self.label_check_box.disabled = not Document.DOCUMENTS_WITH_LABELS.has(document.document_data.code)
	
	return self
