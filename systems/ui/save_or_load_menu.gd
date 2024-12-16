extends Control


@export var container: Control
@export var list_item_scene: PackedScene
var list_items: Array[SaveListItem]
var items_to_display: Array[String]

@export var save_name_line_edit: SaveNameLineEdit


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	clear_container()
	refresh_list_items()
	visibility_changed.connect(refresh_list_items)
	SaveManager.game_saved.connect(refresh_list_items)
	SaveManager.save_deleted.connect(refresh_list_items)


func clear_container() -> void:
	for child: Node in container.get_children():
		child.queue_free()


func create_new_list_item(save_name: String) -> SaveListItem:
	var new_list_item: SaveListItem = (list_item_scene.instantiate() as SaveListItem).with_data(save_name)
	new_list_item.pressed_with_data.connect(_on_list_item_pressed)
	container.add_child(new_list_item)
	list_items.append(new_list_item)
	return new_list_item


func update_list_item(list_item: SaveListItem, save_name: String) -> SaveListItem:
	return list_item.with_data(save_name)


func remove_list_items(ids_to_remove: Array[int]) -> void:
	for id_to_remove: int in ids_to_remove:
		list_items[id_to_remove].queue_free()
		list_items.remove_at(id_to_remove)


func refresh_list_items() -> void:
	filter_and_sort_items()
	
	var items_size: int = items_to_display.size()
	var list_items_size: int = list_items.size()
	var list_item_ids_for_removal: Array[int]
	
	for counter: int in maxi(items_size, list_items_size):
		if counter <= items_size - 1 and counter <= list_items_size - 1:
			update_list_item(list_items[counter], items_to_display[counter])
		elif counter > items_size - 1:
			list_item_ids_for_removal.push_front(counter)
		elif counter > list_items_size - 1:
			create_new_list_item(items_to_display[counter])
	
	remove_list_items(list_item_ids_for_removal)
	
	if SaveManager.is_game_loaded:
		save_name_line_edit.change_text(SaveManager.new_save_name)
	elif not items_to_display.is_empty():
		save_name_line_edit.change_text(items_to_display.front())
	else:
		save_name_line_edit.change_text("")


func filter_and_sort_items() -> void:
	items_to_display = SaveManager.get_save_file_names_from_save_folder()
	items_to_display.sort_custom(func(a: String, b: String) -> bool: return a.naturalnocasecmp_to(b) > 0)


func _on_list_item_pressed(save_name: String) -> void:
	save_name_line_edit.change_text(save_name)
