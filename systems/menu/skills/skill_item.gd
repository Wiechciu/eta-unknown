class_name SkillItem
extends Control


var skill: Skill
@export var skill_icon_rect: TextureRect
@export var skill_name_label: Label
@export var skill_value_label: Label
@export var skill_progress_bar: ProgressBar
@export var skill_checkbox: CheckBox


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(skill: Skill) -> SkillItem:
	self.skill = skill
	self.skill_icon_rect.texture = skill.skill_data.skill_icon if skill.skill_data.skill_icon != null else PlaceholderTexture2D.new()
	self.skill_name_label.text = skill.skill_data.skill_name
	
	update_value()
	
	return self


func update_value() -> void:
	self.skill_value_label.text = "%d" % [skill.value]
	
	if skill.skill_data.max_value == 1:
		skill_checkbox.show()
		skill_progress_bar.hide()
		skill_checkbox.button_pressed = skill.value == skill.skill_data.max_value
	else:
		skill_checkbox.hide()
		skill_progress_bar.show()
		self.skill_progress_bar.value = skill.value
		self.skill_progress_bar.max_value = skill.skill_data.max_value


func get_tooltip_icon() -> Texture2D:
	if skill == null:
		return null
	
	return skill.skill_data.skill_icon


func get_tooltip_header() -> String:
	if skill == null:
		return ""
	
	return "%s (%d / %d)" % [skill.skill_data.skill_name, skill.value, skill.skill_data.max_value]


func get_tooltip_body() -> String:
	if skill == null:
		return ""
	
	return skill.skill_data.skill_description
