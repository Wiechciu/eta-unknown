class_name SkillItem
extends Control


var skill_data: SkillData
@export var skill_icon_rect: TextureRect
@export var skill_name_label: Label
@export var skill_value_label: Label
@export var skill_progress_bar: ProgressBar
@export var skill_checkbox: CheckBox


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(skill_data: SkillData) -> SkillItem:
	self.skill_data = skill_data
	self.skill_icon_rect.texture = skill_data.skill.skill_icon if skill_data.skill.skill_icon != null else PlaceholderTexture2D.new()
	self.skill_name_label.text = skill_data.skill.skill_name
	
	update_value()
	
	return self


func update_value() -> void:
	self.skill_value_label.text = "%d" % [skill_data.value]
	
	if skill_data.skill.max_value == 1:
		skill_checkbox.show()
		skill_progress_bar.hide()
		skill_checkbox.button_pressed = skill_data.value == skill_data.skill.max_value
	else:
		skill_checkbox.hide()
		skill_progress_bar.show()
		self.skill_progress_bar.value = skill_data.value
		self.skill_progress_bar.max_value = skill_data.skill.max_value


func get_tooltip_icon() -> Texture2D:
	if skill_data == null:
		return null
	
	return skill_data.skill.skill_icon


func get_tooltip_header() -> String:
	if skill_data == null:
		return ""
	
	return "%s (%d / %d)" % [skill_data.skill.skill_name, skill_data.value, skill_data.skill.max_value]


func get_tooltip_body() -> String:
	if skill_data == null:
		return ""
	
	return skill_data.skill.skill_description
