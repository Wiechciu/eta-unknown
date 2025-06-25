class_name EmailTemplateItem
extends Control


signal pressed


@export var button: Button
@export var name_label: Label
var email_template: EmailTemplate


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func initiate(email_template: EmailTemplate) -> void:
	self.email_template = email_template
	self.name_label.text = email_template.name


func _on_button_pressed() -> void:
	pressed.emit()
