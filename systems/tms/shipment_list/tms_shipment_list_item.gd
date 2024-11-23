class_name TmsShipmentListItem
extends Control


signal pressed_with_shipment_data(Shipment)


var shipment: Shipment

@export var shipment_number: Label
@export var earliest_pickup_date: Label
@export var shipper: Label
@export var origin: Label
@export var destination: Label
@export var total_weight: Label
@export var status: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func with_data(new_shipment: Shipment) -> TmsShipmentListItem:
	shipment = new_shipment
	
	shipment_number.text = str(shipment.shipment_number)
	earliest_pickup_date.text = GlobalTimer.get_nice_format_date_string(shipment.earliest_pickup_date)
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
