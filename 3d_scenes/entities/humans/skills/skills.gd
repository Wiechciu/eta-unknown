extends Node


var player: Player

var skill_items: Array[SkillItem]
var skill_category_items: Array[SkillCategoryItem]
var is_open: bool:
	get:
		return visual.visible

@export var skill_item_scene: PackedScene
@export var skill_category_item_scene: PackedScene
@export var item_container: Container
@export var visual: Control



func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	close()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if is_open:
			close()
		else:
			open()


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	skill_items.clear()
	skill_category_items.clear()


func populate_container() -> void:
	var last_skill_category: SkillCategory = null
	for skill_data: SkillData in player.person.skills:
		if skill_data.skill.skill_category != last_skill_category:
			add_skill_category(skill_data)
			last_skill_category = skill_data.skill.skill_category
		add_skill(skill_data)


func open() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visual.show()
	clear_container()
	populate_container()


func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visual.hide()


func add_skill(skill_data: SkillData) -> void:
	var new_skill_item: SkillItem = (skill_item_scene.instantiate() as SkillItem).with_data(skill_data)
	item_container.add_child(new_skill_item)
	skill_items.append(new_skill_item)


func add_skill_category(skill_data: SkillData) -> void:
	var new_skill_category_item: SkillCategoryItem = (skill_category_item_scene.instantiate() as SkillCategoryItem).with_data(skill_data.skill.skill_category)
	item_container.add_child(new_skill_category_item)
	skill_category_items.append(new_skill_category_item)
