class_name Email
extends Resource


@export var from: String #TODO: Change to actual person instead of String, same with To
@export var to: String
@export var subject: String
@export_multiline var body: String
@export var date: int
@export var is_read: bool = false
@export var communication_chain: Array[Email] #TODO: attach actual emails


@warning_ignore("shadowed_variable")
static func create_new(from: String, to: String, subject: String, body: String, date: int, is_read: bool = false, communication_chain: Array[Email] = []) -> Email:
	var new_email: Email = Email.new()
	new_email.from = from
	new_email.to = to
	new_email.subject = subject
	new_email.body = body
	new_email.date = date
	new_email.is_read = is_read
	new_email.communication_chain = communication_chain
	
	return new_email


func set_to_read() -> void:
	is_read = true


func set_to_unread() -> void:
	is_read = false
