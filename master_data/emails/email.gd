class_name Email
extends Resource


@export var from: Person #TODO: Change to actual person instead of String, same with To
@export var to: Person
@export var subject: String
@export_multiline var body: String
@export var date: int
@export var attachments: Array[Document]
@export var is_read: bool = false
@export var communication_chain: Array[Email] #TODO: attach actual emails

var is_unread: bool:
	get:
		return not is_read
	set(value):
		is_read = not value


@warning_ignore("shadowed_variable")
static func create_new(from: Person, to: Person, subject: String, body: String, date: int, attachments: Array[Document] = [], is_read: bool = false, communication_chain: Array[Email] = []) -> Email:
	var new_email: Email = Email.new()
	new_email.from = from
	new_email.to = to
	new_email.subject = subject
	new_email.body = body
	new_email.date = date
	new_email.attachments = attachments
	new_email.is_read = is_read
	new_email.communication_chain = communication_chain
	
	return new_email


func set_to_read() -> void:
	is_read = true


func set_to_unread() -> void:
	is_read = false
