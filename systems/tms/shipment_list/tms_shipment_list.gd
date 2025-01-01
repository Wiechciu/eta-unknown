class_name TmsShipmentList
extends Control


enum SortType {
	BY_NUMBER,
	BY_DATE,
}


@export var tms: Tms
@export var container: Control
@export var header: Label
@export var toggle_completed_button: Button
@export var sort_button: Button
@export var list_item_scene: PackedScene
var show_completed: bool = true
var sort_type: SortType
var list_items: Array[TmsShipmentListItem]
var items_to_display: Array[Shipment]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	clear_container()
	#refresh_list_items()


func close() -> void:
	visible = false
	if GameManager.player.person.employer == null:
		return
	
	if (GameManager.player.person.employer as Party).shipment_list_updated.is_connected(refresh_list_items):
		(GameManager.player.person.employer as Party).shipment_list_updated.disconnect(refresh_list_items)


func open() -> void:
	visible = true
	if GameManager.player.person.employer == null:
		return
	
	if not (GameManager.player.person.employer as Party).shipment_list_updated.is_connected(refresh_list_items):
		(GameManager.player.person.employer as Party).shipment_list_updated.connect(refresh_list_items)
	refresh_list_items()


func clear_container() -> void:
	for child: Node in container.get_children():
		child.queue_free()


func create_new_list_item(shipment: Shipment) -> TmsShipmentListItem:
	var new_list_item: TmsShipmentListItem = (list_item_scene.instantiate() as TmsShipmentListItem).with_data(shipment)
	new_list_item.pressed_with_shipment_data.connect(_on_list_item_pressed)
	container.add_child(new_list_item)
	list_items.append(new_list_item)
	return new_list_item


func update_list_item(list_item: TmsShipmentListItem, shipment: Shipment) -> TmsShipmentListItem:
	return list_item.with_data(shipment)


func remove_list_items(ids_to_remove: Array[int]) -> void:
	for id_to_remove: int in ids_to_remove:
		list_items[id_to_remove].queue_free()
		list_items.remove_at(id_to_remove)


func refresh_list_items() -> void:
	filter_and_sort_items()
	header.text = "%s (%d):" % [tr("SHIPMENTS"), items_to_display.size()]
	
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
	if GameManager.player.person.employer == null:
		return
	
	var shipments: Array[Shipment] = (GameManager.player.person.employer as Party).shipments
	if not show_completed:
		var shipments_not_completed: Array[Shipment] = shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_completed_or_cancelled)
		shipments = shipments_not_completed
	
	var shipments_sorted: Array[Shipment]
	match sort_type:
		SortType.BY_NUMBER:
			shipments_sorted = sort_shipment_list_by_shipment_number(shipments)
		SortType.BY_DATE:
			shipments_sorted = sort_shipment_list_by_earliest_pickup_date(shipments)
	
	items_to_display = shipments_sorted


func _on_list_item_pressed(shipment_to_load: Shipment) -> void:
	tms.open_shipment_details(shipment_to_load)


func _on_toggle_completed_button_pressed() -> void:
	show_completed = not show_completed
	if show_completed:
		toggle_completed_button.text = "HIDE_COMPLETED"
	else:
		toggle_completed_button.text = "SHOW_COMPLETED"
	
	refresh_list_items()


func _on_sort_button_pressed() -> void:
	sort_type = SortType.values()[(sort_type + 1) % SortType.size()]
	match sort_type:
		SortType.BY_NUMBER:
			sort_button.text = "SORT_BY_DATE"
		SortType.BY_DATE:
			sort_button.text = "SORT_BY_NUMBER"
	
	refresh_list_items()


func sort_shipment_list_by_shipment_number(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_shipment_number)
	return shipment_list


func sort_shipment_list_by_earliest_pickup_date(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_earliest_pickup_date)
	return shipment_list


func _sort_ascending_by_shipment_number(a: Shipment, b: Shipment) -> bool:
	if a.number < b.number:
		return true
	return false


func _sort_ascending_by_earliest_pickup_date(a: Shipment, b: Shipment) -> bool:
	if a.events.get_first_event_of_code(Event.Code.ERL).time < b.events.get_first_event_of_code(Event.Code.ERL).time:
		return true
	return false
