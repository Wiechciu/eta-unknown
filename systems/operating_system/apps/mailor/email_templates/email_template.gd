class_name EmailTemplate
extends Resource


@export var name: String
@export_multiline var message: String


@warning_ignore("shadowed_variable")
static func create_new(name: String, message: String) -> EmailTemplate:
	var new_email_template: EmailTemplate = EmailTemplate.new()
	new_email_template.name = name
	new_email_template.message = message
	
	return new_email_template
