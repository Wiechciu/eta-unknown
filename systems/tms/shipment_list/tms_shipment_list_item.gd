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

@export var button: Button


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	
	button.pressed.connect(_on_button_pressed)


func with_data(new_shipment: Shipment) -> TmsShipmentListItem:
	shipment = new_shipment
	
	shipment_number_label.text = str(shipment.number)
	earliest_pickup_date_label.text = GlobalTimer.get_nice_date_string_from_event(shipment.events.get_first_event_of_code(Event.Code.ERL))
	shipper_label.text = shipment.shipper.name
	origin_label.text = shipment.origin.code
	destination_label.text = shipment.destination.code
	total_weight_label.text = "%d %s" % [shipment.cargo_details.total_weight, tr("KG")]
	var status_text: String = "STATUS_" + Shipment.Status.keys()[shipment.status]
	status_label.text = status_text
	modulate = get_color_from_shipment_status(shipment.status)
	
	return self


func _on_button_pressed() -> void:
	pressed_with_shipment_data.emit(shipment)


func get_color_from_shipment_status(status: Shipment.Status) -> Color:
	match status:
		Shipment.Status.COMPLETED:
			return Color(0.75, 1.00, 0.85)
		Shipment.Status.CANCELLED:
			return Color.LIGHT_GRAY
		_:
			return Color.WHITE
