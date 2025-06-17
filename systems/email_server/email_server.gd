extends Node


@export var emails: Array[Email]


func register_email(email: Email) -> void:
	emails.append(email)
