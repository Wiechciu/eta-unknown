class_name EmailItem
extends Control


signal opened

@export var style_box_normal: StyleBox
@export var style_box_selected: StyleBox
@export var panel_container_to_apply_style_box: PanelContainer

@export var icon_unread: Texture2D
@export var icon_read: Texture2D

@export var email: Email

@export var button: Button
@export var from_to_label: Label
@export var subject_label: Label
@export var date_label: Label
@export var time_label: Label
@export var icon_rect: TextureRect


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func initialize(email: Email, inbound: bool) -> void:
	self.email = email
	self.from_to_label.text = email.from if inbound else email.to
	self.subject_label.text = email.subject
	self.date_label.text = GlobalTimer.get_nice_short_date_string_from_unix_time(email.date)
	self.time_label.text = GlobalTimer.get_nice_time_string_from_unix_time(email.date)
	update_icon()


func _on_button_pressed() -> void:
	opened.emit()
	set_to_read()


func set_to_read() -> void:
	email.set_to_read()
	update_icon()


func set_to_unread() -> void:
	email.set_to_unread()
	update_icon()


func select() -> void:
	panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_selected)


func deselect() -> void:
	panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_normal)


func update_icon() -> void:
	if email.from == GameManager.player.person.email:
		self.icon_rect.hide()
		return
	self.icon_rect.texture = icon_read if email.is_read else icon_unread
