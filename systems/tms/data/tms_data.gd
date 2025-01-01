class_name TmsData
extends Control


@export var tms: Tms
@export var container: Control
@export var header: Label
@export var party_type_filter: OptionButton
@export var list_item_scene: PackedScene
var list_items: Array[TmsDataPartyListItem]
var items_to_display: Array[Party]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	instantiate_filter()
	clear_container()
	#refresh_list_items()


func close() -> void:
	visible = false


func open() -> void:
	visible = true
	refresh_list_items()


func instantiate_filter() -> void:
	party_type_filter.item_selected.connect(_on_party_type_filter_selected.unbind(1))
	party_type_filter.clear()
	party_type_filter.add_item("PARTY_TYPE_ALL")
	for type: String in Party.Type.keys():
		party_type_filter.add_item("PARTY_TYPE_" + type.to_upper())


func clear_container() -> void:
	for child: Node in container.get_children():
		child.queue_free()


func create_new_list_item(party: Party) -> TmsDataPartyListItem:
	var new_list_item: TmsDataPartyListItem = (list_item_scene.instantiate() as TmsDataPartyListItem).with_data(party)
	new_list_item.pressed_with_party_data.connect(_on_list_item_pressed)
	container.add_child(new_list_item)
	list_items.append(new_list_item)
	return new_list_item


func update_list_item(list_item: TmsDataPartyListItem, party: Party) -> TmsDataPartyListItem:
	return list_item.with_data(party)


func remove_list_items(ids_to_remove: Array[int]) -> void:
	for id_to_remove: int in ids_to_remove:
		list_items[id_to_remove].queue_free()
		list_items.remove_at(id_to_remove)


func refresh_list_items() -> void:
	filter_and_sort_items()
	header.text = "%s (%d):" % [tr("PARTIES"), items_to_display.size()]
	
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


func filter_and_sort_items() -> void:
	items_to_display = GlobalRefs.parties
	
	if party_type_filter.selected > 0:
		items_to_display = items_to_display.filter(func(party: Party) -> bool: return party.type == party_type_filter.selected -1) ## -1 because "ALL" is added at the beginning


func _on_list_item_pressed(party: Party) -> void:
	tms.open_party_details(party)


func _on_party_type_filter_selected() -> void:
	refresh_list_items()
