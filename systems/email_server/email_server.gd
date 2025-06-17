extends Node


signal email_registered(email: Email)

@export var emails: Array[Email]
const REPLY_SUBJECT_PREFIX: String = "RE: "
const LINE_BREAK: String = "\n"
const EMAIL_SEPARATOR: String = "______________________________"


func _ready() -> void:
	if GameManager.player == null:
		await GameManager.player_assigned
	
	for email: Email in emails:
		email.date = GlobalTimer.now
		email.from = GlobalRefs.people.filter(func(person: Person) -> bool: return person != GameManager.player.person).pick_random()
		email.to = GameManager.player.person


func register_email(email: Email) -> void:
	emails.append(email)
	email_registered.emit(email)
	
	if email.from == GameManager.player.person:
		schedule_response(email)


func schedule_response(original_email: Email) -> void:
	var response_delay_min: float = 2.0
	var response_delay_max: float = 10.0
	await get_tree().create_timer(randf_range(response_delay_min, response_delay_max)).timeout
	
	var new_email: Email = Email.create_new(
		original_email.to,
		original_email.from,
		REPLY_SUBJECT_PREFIX + original_email.subject,
		add_message_and_footer_to_beginning("Hello," \
		+ LINE_BREAK + "Well noted, thank you!",
		original_email.body, original_email.to),
		GlobalTimer.now
	)
	register_email(new_email)


func add_message_and_footer_to_beginning(message: String, body: String, person: Person) -> String:
	return message \
	+ add_footer_and_separator_to_beginning(body, person)


func add_footer_and_separator_to_beginning(body: String, person: Person) -> String:
	return get_footer(person) \
	+ LINE_BREAK + EMAIL_SEPARATOR \
	+ LINE_BREAK + body


func get_footer(person: Person) -> String:
	return LINE_BREAK \
	+ LINE_BREAK + "[i]" + "Best regards," \
	+ LINE_BREAK + person.full_name \
	+ LINE_BREAK + person.job_position.title \
	+ LINE_BREAK + person.email \
	+ LINE_BREAK + person.phone_number \
	+ LINE_BREAK + person.employer.print_string + "[/i]" 
