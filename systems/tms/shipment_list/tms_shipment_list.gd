class_name TmsShipmentList
extends Control


enum SortType {
	BY_NUMBER,
	BY_DATE,
}


@export var _tms: Tms
@export var _shipment_container: Control
@export var _shipments_header: Label
@export var _toggle_completed_button: Button
@export var _sort_button: Button
@export var _shipment_list_item_scene: PackedScene
var show_completed: bool = true
var sort_type: SortType
var shipment_list_items: Array[TmsShipmentListItem]
var thread: Thread
var shipments_to_display: Array[Shipment]


func refresh_shipment_list_items_on_thread() -> void:
	if thread != null:
		thread.wait_to_finish()
	thread = Thread.new()
	thread.start(refresh_shipment_list_items)


# Thread must be disposed (or "joined"), for portability.
func _exit_tree() -> void:
	if thread != null:
		thread.wait_to_finish()


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	clear_shipment_container()
	refresh_shipment_list_items()


func close() -> void:
	visible = false
	if GameManager.player_company.shipment_list_updated.is_connected(refresh_shipment_list_items):
		GameManager.player_company.shipment_list_updated.disconnect(refresh_shipment_list_items)


func open() -> void:
	visible = true
	if not GameManager.player_company.shipment_list_updated.is_connected(refresh_shipment_list_items):
		GameManager.player_company.shipment_list_updated.connect(refresh_shipment_list_items)
	refresh_shipment_list_items()


func clear_shipment_container() -> void:
	for child: Node in _shipment_container.get_children():
		child.queue_free()


func create_new_shipment_list_item(new_shipment: Shipment) -> TmsShipmentListItem:
	var new_shipment_list_item: TmsShipmentListItem = (_shipment_list_item_scene.instantiate() as TmsShipmentListItem).with_data(new_shipment)
	new_shipment_list_item.pressed_with_shipment_data.connect(_on_shipment_list_item_pressed)
	_shipment_container.add_child(new_shipment_list_item)
	shipment_list_items.append(new_shipment_list_item)
	return new_shipment_list_item


func update_shipment_list_item(shipment_list_item: TmsShipmentListItem, new_shipment: Shipment) -> TmsShipmentListItem:
	return shipment_list_item.with_data(new_shipment)


func remove_shipment_list_items(ids_to_remove: Array[int]) -> void:
	for id_to_remove: int in ids_to_remove:
		shipment_list_items[id_to_remove].queue_free()
		shipment_list_items.remove_at(id_to_remove)


func refresh_shipment_list_items() -> void:
	filter_and_sort_shipment_list()
	_shipments_header.text = "%s (%d):" % [tr("SHIPMENTS"), shipments_to_display.size()]
	
	var shipments_size: int = shipments_to_display.size()
	var list_items_size: int = shipment_list_items.size()
	var list_item_ids_for_removal: Array[int]
	
	for counter: int in maxi(shipments_size, list_items_size):
		if counter <= shipments_size - 1 and counter <= list_items_size - 1:
			update_shipment_list_item(shipment_list_items[counter], shipments_to_display[counter])
		elif counter > shipments_size - 1:
			list_item_ids_for_removal.push_front(counter)
		elif counter > list_items_size - 1:
			create_new_shipment_list_item(shipments_to_display[counter])
	
	remove_shipment_list_items(list_item_ids_for_removal)


func filter_and_sort_shipment_list() -> void:
	var shipments: Array[Shipment] = (GameManager.player_company as FreightForwarder).shipments
	if not show_completed:
		var shipments_not_completed: Array[Shipment] = shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_completed_or_cancelled)
		shipments = shipments_not_completed
	
	var shipments_sorted: Array[Shipment]
	match sort_type:
		SortType.BY_NUMBER:
			shipments_sorted = sort_shipment_list_by_shipment_number(shipments)
		SortType.BY_DATE:
			shipments_sorted = sort_shipment_list_by_earliest_pickup_date(shipments)
	
	shipments_to_display = shipments_sorted


func _on_shipment_list_item_pressed(shipment_to_load: Shipment) -> void:
	_tms.open_shipment_details(shipment_to_load)


func _on_toggle_completed_button_pressed() -> void:
	show_completed = not show_completed
	if show_completed:
		_toggle_completed_button.text = tr("HIDE_COMPLETED")
	else:
		_toggle_completed_button.text = tr("SHOW_COMPLETED")
	
	refresh_shipment_list_items()


func _on_sort_button_pressed() -> void:
	sort_type = SortType.values()[(sort_type + 1) % SortType.size()]
	match sort_type:
		SortType.BY_NUMBER:
			_sort_button.text = tr("SORT_BY_DATE")
		SortType.BY_DATE:
			_sort_button.text = tr("SORT_BY_NUMBER")
	
	refresh_shipment_list_items()


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
	if a.events.get_first_event_of_type(Event.Code.ERL).time < b.events.get_first_event_of_type(Event.Code.ERL).time:
		return true
	return false
