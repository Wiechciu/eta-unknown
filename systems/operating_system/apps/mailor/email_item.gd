@tool
class_name EmailItem
extends Control


signal opened

@export var style_box_read: StyleBox
@export var style_box_unread: StyleBox
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

var is_inbound: bool
var is_outbound: bool:
	get:
		return not is_inbound
	set(value):
		is_inbound = not value
var is_selected: bool

@export_tool_button("change_to_read") var change_to_read: Callable = func() -> void: panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_read)
@export_tool_button("change_to_unread") var change_to_unread: Callable = func() -> void: panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_unread)
@export_tool_button("change_to_selected") var change_to_selected: Callable = func() -> void: panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_selected)


func _ready() -> void:
	button.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func initialize(email: Email, is_inbound: bool) -> void:
	self.email = email
	self.is_inbound = is_inbound
	self.from_to_label.text = email.from.email if is_inbound else email.to.email
	self.subject_label.text = email.subject
	self.date_label.text = GlobalTimer.get_nice_short_date_string_from_unix_time(email.date)
	self.time_label.text = GlobalTimer.get_nice_time_string_from_unix_time(email.date)
	if is_outbound:
		self.icon_rect.hide()
	update_style()
	


func _on_button_pressed() -> void:
	opened.emit()


func set_to_read() -> void:
	email.set_to_read()
	update_style()


func set_to_unread() -> void:
	email.set_to_unread()
	update_style()


func select() -> void:
	is_selected = true
	update_style()


func deselect() -> void:
	is_selected = false
	update_style()


func update_style() -> void:
	if is_selected:
		panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_selected)
	elif email.is_read or is_outbound:
		panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_read)
	else:
		panel_container_to_apply_style_box.add_theme_stylebox_override("panel", style_box_unread)
	
	if is_inbound:
		self.icon_rect.texture = icon_read if email.is_read else icon_unread
