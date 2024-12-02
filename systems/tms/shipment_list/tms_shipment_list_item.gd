class_name TmsShipmentListItem
extends Control


signal pressed_with_shipment_data(shipment: Shipment)


var shipment: Shipment

@export var _shipment_number: Label
@export var _earliest_pickup_date: Label
@export var _shipper: Label
@export var _origin: Label
@export var _destination: Label
@export var _total_weight: Label
@export var _status: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(new_shipment: Shipment) -> TmsShipmentListItem:
	shipment = new_shipment
	
	_shipment_number.text = str(shipment.number)
	_earliest_pickup_date.text = GlobalTimer.get_nice_date_string_from_event(shipment.events.get_first_event_of_type(Event.Code.ERL))
	_shipper.text = shipment.shipper.name
	_origin.text = shipment.origin.code
	_destination.text = shipment.destination.code
	_total_weight.text = "%d kg" % [shipment.cargo_details.total_weight]
	_status.text = Shipment.Status.keys()[shipment.status]
	match shipment.status:
		Shipment.Status.COMPLETED:
			modulate = Color.LIGHT_GREEN
		Shipment.Status.CANCELLED:
			modulate = Color.LIGHT_GRAY
		_:
			modulate = Color.WHITE
	return self


func _on_button_pressed() -> void:
	pressed_with_shipment_data.emit(shipment)
