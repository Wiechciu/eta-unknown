class_name TmsShipmentListItem
extends Control


signal pressed_with_shipment_data(shipment: Shipment)


var shipment: Shipment

@export var shipment_number_label: Label
@export var earliest_pickup_date_label: Label
@export var shipper_label: Label
@export var origin_label: Label
@export var destination_label: Label
@export var total_weight_label: Label
@export var status_label: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(new_shipment: Shipment) -> TmsShipmentListItem:
	shipment = new_shipment
	
	shipment_number_label.text = str(shipment.number)
	earliest_pickup_date_label.text = GlobalTimer.get_nice_date_string_from_event(shipment.events.get_first_event_of_type(Event.Code.ERL))
	shipper_label.text = shipment.shipper.name
	origin_label.text = shipment.origin.code
	destination_label.text = shipment.destination.code
	total_weight_label.text = "%d %s" % [shipment.cargo_details.total_weight, tr("KG")]
	var status_text: String = "STATUS_" + Shipment.Status.keys()[shipment.status]
	status_label.text = status_text
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
