class_name Email
extends Resource


@export var from: Person
@export var to: Person
@export var subject: String
@export_multiline var body: String
@export var date: int
@export var attachments: Array[Document]
@export var is_read: bool = false
@export var communication_chain: Array[Email]

var is_unread: bool:
	get:
		return not is_read
	set(value):
		is_read = not value


@warning_ignore("shadowed_variable")
static func create_new(from: Person, to: Person, subject: String, body: String, date: int, attachments: Array[Document], original_email: Email, is_read: bool = false) -> Email:
	var new_email: Email = Email.new()
	new_email.from = from
	new_email.to = to
	new_email.subject = subject
	new_email.body = body
	new_email.date = date
	new_email.attachments = attachments
	new_email.is_read = is_read
	if original_email != null:
		new_email.communication_chain = original_email.communication_chain.duplicate()
		new_email.communication_chain.append(original_email)
	
	return new_email


func set_to_read() -> void:
	is_read = true


func set_to_unread() -> void:
	is_read = false
