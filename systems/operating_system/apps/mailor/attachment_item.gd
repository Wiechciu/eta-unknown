class_name AttachmentItem
extends Control


signal opened


@export var document: Document

@export var button: Button
@export var name_label: Label


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	
	if document != null:
		initialize(document)


@warning_ignore("shadowed_variable")
func initialize(document: Document) -> void:
	self.document = document
	self.name_label.text = generate_attachment_name_for_document(document)


func _on_button_pressed() -> void:
	opened.emit()


@warning_ignore("shadowed_variable")
func generate_attachment_name_for_document(document: Document) -> String:
	var sanitized: String = document.document_data.name.to_lower()
	var regex: RegEx = RegEx.new()
	
	# Keep only a-z and 0-9; remove everything else
	regex.compile("[^a-z0-9]")
	sanitized = regex.sub(sanitized, "", true)
	sanitized = "%s_%s.%s" % [sanitized, document.number, "doc"]
	
	return sanitized
