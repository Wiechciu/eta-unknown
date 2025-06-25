class_name ReplyWithTemplateButton
extends Control


signal pressed(email_template_item: EmailTemplateItem)


@export var button: Button
@export var visual_container: Control
@export var email_template_items_container: Control
@export var email_template_item_scene: PackedScene
var email_template_items: Array[EmailTemplateItem]


@export var email_templates: Array[EmailTemplate]


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)
	visual_container.hide()
	clear_container()
	populate_container()


func clear_container() -> void:
	for child: Node in email_template_items_container.get_children():
		if child is EmailTemplateItem:
			child.queue_free()


func populate_container() -> void:
	for email_template: EmailTemplate in email_templates:
		var new_email_template_item: EmailTemplateItem = email_template_item_scene.instantiate()
		new_email_template_item.initiate(email_template)
		new_email_template_item.pressed.connect(_on_email_template_button_pressed.bind(new_email_template_item))
		email_template_items_container.add_child(new_email_template_item)
		email_template_items.append(new_email_template_item)


func _on_button_pressed() -> void:
	if visual_container.visible:
		visual_container.hide()
	else:
		visual_container.show()


func _on_email_template_button_pressed(email_template_item: EmailTemplateItem) -> void:
	pressed.emit(email_template_item)
	visual_container.hide()
