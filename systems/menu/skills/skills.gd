extends Control


var player: Player

var skill_items: Array[SkillItem]
var skill_category_items: Array[SkillCategoryItem]

@export var skill_item_scene: PackedScene
@export var skill_category_item_scene: PackedScene
@export var scroll_container: ScrollContainer
@export var item_container: Container


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	
	visibility_changed.connect(on_visibility_changed)


func on_visibility_changed() -> void:
	if visible:
		clear_container()
		populate_container()
		scroll_container.scroll_vertical = 0


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	skill_items.clear()
	skill_category_items.clear()


func populate_container() -> void:
	if player.person == null:
		await player.person_assigned
	
	var last_skill_category: SkillCategory = null
	for skill_data: SkillData in player.person.skills:
		if skill_data.skill.skill_category != last_skill_category:
			add_skill_category(skill_data)
			last_skill_category = skill_data.skill.skill_category
		add_skill(skill_data)


func add_skill(skill_data: SkillData) -> void:
	var new_skill_item: SkillItem = (skill_item_scene.instantiate() as SkillItem).with_data(skill_data)
	item_container.add_child(new_skill_item)
	skill_items.append(new_skill_item)


func add_skill_category(skill_data: SkillData) -> void:
	var new_skill_category_item: SkillCategoryItem = (skill_category_item_scene.instantiate() as SkillCategoryItem).with_data(skill_data.skill.skill_category)
	item_container.add_child(new_skill_category_item)
	skill_category_items.append(new_skill_category_item)
