class_name PersonalInfoItem
extends Control


var personal_info: PersonalInfo
@export var icon_rect: TextureRect
@export var name_label: Label
@export var value_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(personal_info: PersonalInfo) -> PersonalInfoItem:
	self.personal_info = personal_info
	self.icon_rect.texture = personal_info.personal_info_data.icon if personal_info.personal_info_data.icon != null else PlaceholderTexture2D.new()
	self.name_label.text = personal_info.personal_info_data.name
	self.value_label.text = personal_info.value
	
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
