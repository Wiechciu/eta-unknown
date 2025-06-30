extends Node


signal email_registered(email: Email)

const REPLY_SUBJECT_PREFIX: String = "RE: "
const LINE_BREAK: String = "\n"
const EMAIL_SUBJECTS: Array[String] = preload("res://systems/email_server/email_subjects_general.json").data
const EMAIL_SUBJECTS_RFQ: Array[String] = preload("res://systems/email_server/email_subjects_rfq.json").data
const EMAIL_SUBJECTS_SPO: Array[String] = preload("res://systems/email_server/email_subjects_spo.json").data
const EMAIL_KEYWORDS_ACCEPT: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.ACCEPT
const EMAIL_KEYWORDS_DECLINE: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.DECLINE
const EMAIL_KEYWORDS_REQUEST_INFO: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.REQUEST_INFO
const EMAIL_KEYWORDS_CANCEL: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.CANCEL
const EMAIL_KEYWORDS_GREETING: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.GREETING
const EMAIL_KEYWORDS_THANKFUL: Array[String] = preload("res://systems/operating_system/apps/mailor/email_keywords.json").data.THANKFUL


@export var emails: Array[Email]


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
	+ LINE_BREAK + "Best regards," \
	+ LINE_BREAK + person.full_name \
	+ LINE_BREAK + person.job_position.title \
	+ LINE_BREAK + person.email \
	+ LINE_BREAK + person.phone_number \
	+ LINE_BREAK + person.employer.print_string 
