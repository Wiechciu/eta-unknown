class_name ShippingOrder
extends DocumentLayout


@export_category("Assigned internally")
@export var _shipper: Label
@export var _consignee: Label
@export var _origin: Label
@export var _destination: Label
@export var _total_quantity: Label
@export var _total_weight: Label
@export var _total_volume: Label
@export var _dimension_sets_container: Control
@export var _document_dimension_set_scene: PackedScene


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_shipper.text = shipment.shipper.print_string
	_consignee.text = shipment.consignee.print_string
	_origin.text = shipment.origin.print_string
	_destination.text = shipment.destination.print_string
	_total_quantity.text = str(shipment.cargo_details.total_quantity)
	_total_weight.text = str(shipment.cargo_details.total_weight)
	_total_volume.text = str(shipment.cargo_details.total_volume)
	
	for child: Node in _dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set: DimensionSet in shipment.cargo_details.dimension_sets:
		var document_dimension_set: DocumentDimensionSet = (_document_dimension_set_scene.instantiate() as DocumentDimensionSet).with_data(dimension_set)
		_dimension_sets_container.add_child(document_dimension_set)


func _on_accept_button_pressed() -> void:
	if GameManager.player.person.employer == null:
		return
	shipment.accept(GameManager.player.person.employer as FreightForwarder)
	queue_free()


func _on_reject_button_pressed() -> void:
	queue_free()
