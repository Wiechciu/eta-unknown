class_name PersonalInfoItem
extends Control


var personal_info: PersonalInfo
@export var icon_rect: TextureRect
@export var name_label: Label
@export var value_label: Label
@export var edit: LineEdit


func _gui_input(event: InputEvent) -> void:
	if not personal_info.personal_info_data.editable:
		return
	if event is InputEventMouseButton:
		if event.double_click:
			if event.button_index == MOUSE_BUTTON_LEFT:
				start_editing()


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func initialize(personal_info: PersonalInfo) -> PersonalInfoItem:
	self.personal_info = personal_info
	self.icon_rect.texture = personal_info.personal_info_data.icon if personal_info.personal_info_data.icon != null else PlaceholderTexture2D.new()
	self.name_label.text = personal_info.personal_info_data.name
	self.value_label.text = personal_info.value
	self.edit.text = personal_info.value
	self.edit.hide()
	
	if personal_info.personal_info_data.editable:
		edit.editing_toggled.connect(func(toggled_on: bool) -> void: if not toggled_on: end_editing())
		edit.focus_exited.connect(end_editing)
	
	return self


func get_tooltip_icon() -> Texture2D:
	if personal_info == null:
		return null
	
	return personal_info.personal_info_data.icon


func get_tooltip_header() -> String:
	if personal_info == null:
		return ""
	
	return personal_info.personal_info_data.name


func get_tooltip_body() -> String:
	if personal_info == null:
		return ""
	
	return personal_info.personal_info_data.description


func start_editing() -> void:
	value_label.hide()
	edit.show()
	edit.select_all()
	edit.grab_focus()


func end_editing() -> void:
	value_label.show()
	edit.hide()
	personal_info.update_person(edit.text)
	edit.text = personal_info.value
	value_label.text = personal_info.value
