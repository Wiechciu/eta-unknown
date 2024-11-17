class_name ShippingOrder
extends Document


var shipment: Shipment

@export_category("Assigned internally")
@export var shipper: Label
@export var consignee: Label
@export var origin: Label
@export var destination: Label
@export var total_quantity: Label
@export var total_weight: Label
@export var total_volume: Label
@export var dimension_sets_container: Control
@export var document_dimension_set_scene: PackedScene


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	shipper.text = shipment.shipper.print_string
	consignee.text = shipment.consignee.print_string
	origin.text = shipment.origin.print_string
	destination.text = shipment.destination.print_string
	total_quantity.text = str(shipment.total_quantity)
	total_weight.text = str(shipment.total_weight)
	total_volume.text = str(shipment.total_volume)
	
	for child in dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set in shipment.dimension_sets:
		var document_dimension_set: DocumentDimensionSet = document_dimension_set_scene.instantiate()
		document_dimension_set.quantity.text = str(dimension_set.quantity)
		document_dimension_set.length.text = str(dimension_set.length)
		document_dimension_set.width.text = str(dimension_set.width)
		document_dimension_set.height.text = str(dimension_set.height)
		document_dimension_set.total_weight.text = str(dimension_set.total_weight)
		dimension_sets_container.add_child(document_dimension_set)


func _on_accept_button_pressed() -> void:
	shipment.accept(GameManager.player.employer)
	queue_free()


func _on_reject_button_pressed() -> void:
	queue_free()
