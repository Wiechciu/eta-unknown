class_name TmsShipmentList
extends Control


enum SortType {
	BY_NUMBER,
	BY_DATE,
}

@export var _tms: Tms
@export var _shipment_container: Control
@export var _toggle_completed_button: Button
@export var _sort_button: Button
@export var _shipment_list_item_scene: PackedScene
var show_completed: bool = true
var sort_type: SortType


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	if not GameManager.is_node_ready():
		await GameManager.ready
	refresh_shipment_list_items()
	(GameManager.player_company as FreightForwarder).shipment_list_updated.connect(_on_shipment_list_updated)


func add_shipment(new_shipment: Shipment) -> void:
	var new_shipment_list_item: TmsShipmentListItem = (_shipment_list_item_scene.instantiate() as TmsShipmentListItem).with_data(new_shipment)
	new_shipment_list_item.name = "Shipment_" + str(new_shipment_list_item.shipment.id)
	new_shipment_list_item.pressed_with_shipment_data.connect(_on_shipment_list_item_pressed)
	_shipment_container.add_child(new_shipment_list_item)


func refresh_shipment_list_items() -> void:
	for child: Node in _shipment_container.get_children():
		child.queue_free()
	
	var shipments: Array[Shipment] = (GameManager.player_company as FreightForwarder).shipments
	if not show_completed:
		var shipments_not_completed: Array[Shipment] = shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_completed)
		shipments = shipments_not_completed
	
	var shipments_sorted: Array[Shipment]
	match sort_type:
		SortType.BY_NUMBER:
			shipments_sorted = Shipment.sort_shipment_list_by_shipment_number(shipments)
		SortType.BY_DATE:
			shipments_sorted = Shipment.sort_shipment_list_by_earliest_pickup_date(shipments)
	
	
	for shipment: Shipment in shipments_sorted:
		add_shipment(shipment)


func _on_shipment_list_updated() -> void:
	refresh_shipment_list_items()


func _on_shipment_list_item_pressed(shipment_to_load: Shipment) -> void:
	_tms.open_shipment_details(shipment_to_load)


func _on_toggle_completed_button_pressed() -> void:
	show_completed = not show_completed
	if show_completed:
		_toggle_completed_button.text = "hide completed"
	else:
		_toggle_completed_button.text = "show completed"
	
	refresh_shipment_list_items()


func _on_sort_button_pressed() -> void:
	sort_type = SortType.values()[(sort_type + 1) % SortType.size()]
	match sort_type:
		SortType.BY_NUMBER:
			_sort_button.text = "sort by date"
		SortType.BY_DATE:
			_sort_button.text = "sort by number"
	
	refresh_shipment_list_items()
