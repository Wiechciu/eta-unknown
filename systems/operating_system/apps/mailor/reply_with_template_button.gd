class_name ReplyWithTemplateButton
extends Control


signal template_selected(email_template: EmailTemplate)


@export var button: Button
@export var email_templates: Array[EmailTemplate]
@export var popup_menu: PopupMenu


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	clear_items()
	add_items()
	popup_menu.id_pressed.connect(_on_item_pressed)
	popup_menu.hide()


func clear_items() -> void:
	popup_menu.clear()


func add_items() -> void:
	for email_template: EmailTemplate in email_templates:
		popup_menu.add_item(email_template.name)


func _on_button_pressed() -> void:
	popup_menu.show()
	popup_menu.position = global_position + Vector2(0, size.y + 5)


func _on_item_pressed(id: int) -> void:
	template_selected.emit(email_templates[id])
