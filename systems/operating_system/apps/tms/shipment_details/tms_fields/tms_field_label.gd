@tool
class_name TmsFieldLabel
extends HBoxContainer


@export var label_text: String:
	set(new_text):
		label_text = new_text
		label.text = new_text
@export var label: Label
