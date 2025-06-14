extends Control


var player: Player

var personal_info_items: Array[PersonalInfoItem]

@export var personal_info_item_scene: PackedScene
@export var item_container: Container


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	
	visibility_changed.connect(on_visibility_changed)


func on_visibility_changed() -> void:
	if visible:
		clear_container()
		populate_container()


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	personal_info_items.clear()


func populate_container() -> void:
	if player.person == null:
		await player.person_assigned
	
	for personal_info: PersonalInfo in player.person.personal_infos:
		add_personal_info(personal_info)


func add_personal_info(personal_info: PersonalInfo) -> void:
	var new_personal_info_item: PersonalInfoItem = (personal_info_item_scene.instantiate() as PersonalInfoItem).with_data(personal_info)
	item_container.add_child(new_personal_info_item)
	personal_info_items.append(new_personal_info_item)
