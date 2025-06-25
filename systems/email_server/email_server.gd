extends Node


signal email_registered(email: Email)

@export var emails: Array[Email]
const REPLY_SUBJECT_PREFIX: String = "RE: "
const LINE_BREAK: String = "\n"
const EMAIL_SUBJECTS: Array[String] = preload("res://systems/email_server/email_subjects_general.json").data
const EMAIL_SUBJECTS_RFQ: Array[String] = preload("res://systems/email_server/email_subjects_rfq.json").data
const EMAIL_SUBJECTS_SPO: Array[String] = preload("res://systems/email_server/email_subjects_spo.json").data


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


func get_footer(person: Person) -> String:
	return LINE_BREAK \
	+ LINE_BREAK + "[i]" + "Best regards," \
	+ LINE_BREAK + person.full_name \
	+ LINE_BREAK + person.job_position.title \
	+ LINE_BREAK + person.email \
	+ LINE_BREAK + person.phone_number \
	+ LINE_BREAK + person.employer.print_string + "[/i]" 
