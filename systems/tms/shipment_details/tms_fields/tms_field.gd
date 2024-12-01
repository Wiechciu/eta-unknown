@tool
class_name TmsField
extends HBoxContainer


@export var label_text: String:
	set(new_text):
		label_text = new_text
		label.text = new_text
@export var value_text: String:
	set(new_text):
		value_text = new_text
		value.text = new_text
@export var label: Label
@export var value: Label
