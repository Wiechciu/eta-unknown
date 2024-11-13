class_name ShipmentList
extends Control


@export var _shipment_container: Control
@export var _completed_shipments: Label
@export var _shipment_list_item_scene: PackedScene
@export var _toggle_shipments_button: Button


func _ready() -> void:
	show_shipment_list_items()
	GameManager.player.employer.shipment_list_updated.connect(_on_shipment_list_updated)


func add_shipment(new_shipment: Shipment) -> void:
	var new_shipment_list_item: ShipmentListItem = _shipment_list_item_scene.instantiate().with_data(new_shipment)
	new_shipment_list_item.name = "Shipment_" + str(new_shipment_list_item.shipment.shipment_id)
	_shipment_container.add_child(new_shipment_list_item)


func show_shipment_list_items() -> void:
	for child in _shipment_container.get_children():
		child.queue_free()
	
	for shipment in GameManager.player.employer.shipments.filter(Shipment.is_shipment_not_completed):
		add_shipment(shipment)
	
	_toggle_shipments_button.text = "-"
	_shipment_container.visible = true


func hide_shipment_list_items() -> void:
	_toggle_shipments_button.text = "+"
	_shipment_container.visible = false


func _on_toggle_shipment_list_button_pressed() -> void:
	if _shipment_container.visible:
		hide_shipment_list_items()
	else:
		show_shipment_list_items()


func _on_shipment_list_updated() -> void:
	if _shipment_container.visible:
		show_shipment_list_items()
	_completed_shipments.text = "Completed: " + str(GameManager.player.employer.shipments.filter(Shipment.is_shipment_completed).size())
