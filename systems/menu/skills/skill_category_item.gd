class_name SkillCategoryItem
extends Control


var skill_category: SkillCategory
@export var skill_category_name_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func initialize(skill_category: SkillCategory) -> SkillCategoryItem:
	self.skill_category = skill_category
	self.skill_category_name_label.text = skill_category.category_name
	
	return self


func get_tooltip_icon() -> Texture2D:
	if skill_category == null:
		return null
	
	return skill_category.category_icon


func get_tooltip_header() -> String:
	if skill_category == null:
		return ""
	
	return skill_category.category_name


func get_tooltip_body() -> String:
	if skill_category == null:
		return ""
	
	return skill_category.category_description
