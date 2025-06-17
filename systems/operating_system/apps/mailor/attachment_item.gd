class_name AttachmentItem
extends Control


signal opened
signal removed


var document: Document

@export var open_attachment_button: Button
@export var remove_attachment_button: Button
@export var remove_attachment_button_container: Control
@export var name_label: Label


func _ready() -> void:
	open_attachment_button.pressed.connect(_on_open_attachment_button_pressed)
	remove_attachment_button.pressed.connect(_on_remove_attachment_button_pressed)


@warning_ignore("shadowed_variable")
func initialize(document: Document, is_read_only: bool) -> void:
	self.document = document
	self.name_label.text = generate_attachment_name_for_document(document)
	
	if is_read_only:
		remove_attachment_button_container.hide()
	else:
		remove_attachment_button_container.show()


func _on_open_attachment_button_pressed() -> void:
	opened.emit()


func _on_remove_attachment_button_pressed() -> void:
	removed.emit()


@warning_ignore("shadowed_variable")
func generate_attachment_name_for_document(document: Document) -> String:
	var sanitized: String = document.document_data.name.to_lower()
	var regex: RegEx = RegEx.new()
	
	# Keep only a-z and 0-9; remove everything else
	regex.compile("[^a-z0-9]")
	sanitized = regex.sub(sanitized, "", true)
	sanitized = "%s_%s.%s" % [sanitized, document.number, "doc"]
	
	return sanitized
