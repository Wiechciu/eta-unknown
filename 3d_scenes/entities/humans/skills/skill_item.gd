class_name SkillItem
extends Control


var skill_data: SkillData
@export var skill_name_label: Label
@export var skill_value_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(skill_data: SkillData) -> SkillItem:
	self.skill_data = skill_data
	self.skill_name_label.text = skill_data.skill.skill_name
	self.skill_value_label.text = "%d / %d" % [skill_data.value, skill_data.skill.max_value]
	
	return self


func get_tooltip_header() -> String:
	return skill_data.skill.skill_name


func get_tooltip_body() -> String:
	return skill_data.skill.skill_description
