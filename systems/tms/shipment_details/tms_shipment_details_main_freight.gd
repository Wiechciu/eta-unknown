class_name TmsShipmentDetailsMainFreight
extends PanelContainer


var shipment: Shipment
@export var _mode_of_transport: TmsField
@export var _carrier: TmsField
@export var _planned_departure: TmsField
@export var _planned_arrival: TmsField

@export var _arrange_main_freight_button: Button


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	_arrange_main_freight_button.pressed.connect(_on_arrange_main_freight_button_pressed)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_mode_of_transport.value.text = shipment.main_freight.mode_of_transport.name if shipment.main_freight.mode_of_transport else ""
	_carrier.value.text = shipment.main_freight.carrier.name if shipment.main_freight.carrier else ""
	_planned_departure.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_code(Event.Code.DEP))
	_planned_arrival.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_code(Event.Code.ARR))


func _on_arrange_main_freight_button_pressed() -> void:
	shipment.main_freight.mode_of_transport = ModeOfTransport.new().with_data_random()
	shipment.main_freight.carrier = GlobalRefs.carriers.pick_random()
	shipment.events.create_new_planned_event(Event.Code.DEP, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_code(Event.Code.ERL), 1, 12))
	shipment.events.create_new_planned_event(Event.Code.ARR, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_code(Event.Code.LTS), -1, 12))
	refresh()
