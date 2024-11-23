class_name ShipmentListItem
extends Control


signal pressed_with_shipment_data(Shipment)


var shipment: Shipment

@export var shipment_number: Label
@export var shipper: Label
@export var origin: Label
@export var destination: Label
@export var total_weight: Label
@export var status: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func with_data(new_shipment: Shipment) -> ShipmentListItem:
	shipment = new_shipment
	
	shipment_number.text = str(shipment.shipment_number)
	shipper.text = shipment.shipper.name
	origin.text = shipment.origin.code
	destination.text = shipment.destination.code
	total_weight.text = "%d kg" % [shipment.cargo_details.total_weight]
	status.text = Shipment.Status.keys()[shipment.status]
	match shipment.status:
		Shipment.Status.COMPLETED:
			modulate = Color.LIGHT_GREEN
	return self


func _on_button_pressed() -> void:
	pressed_with_shipment_data.emit(shipment)
