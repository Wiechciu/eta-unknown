class_name TmsShipmentDetailsHaulage
extends PanelContainer


var shipment: Shipment
@export var _trucker_pickup: Label
@export var _trucker_delivery: Label
@export var _planned_pickup: Label
@export var _planned_delivery: Label

@export var _arrange_pickup_button: Button
@export var _arrange_delivery_button: Button


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
	
	_arrange_pickup_button.pressed.connect(_on_arrange_pickup_button_pressed)
	_arrange_delivery_button.pressed.connect(_on_arrange_delivery_button_pressed)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_trucker_pickup.text = shipment.haulage.trucker_pickup.name if shipment.haulage.trucker_pickup else ""
	_trucker_delivery.text = shipment.haulage.trucker_delivery.name if shipment.haulage.trucker_delivery else ""
	_planned_pickup.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.PUP))
	_planned_delivery.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.DEL))


func _on_arrange_pickup_button_pressed() -> void:
	shipment.haulage.trucker_pickup = GlobalRefs.truckers.pick_random()
	shipment.events.create_new_planned_event(Event.Code.PUP, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.ERL), 0, 12))
	shipment.events.create_new_planned_event(Event.Code.RCV, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.PUP), 0, 17))
	refresh()


func _on_arrange_delivery_button_pressed() -> void:
	shipment.haulage.trucker_delivery = GlobalRefs.truckers.pick_random()
	shipment.events.create_new_planned_event(Event.Code.REL, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.LTS), 0, 6))
	shipment.events.create_new_planned_event(Event.Code.DEL, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.REL), 0, 8))
	refresh()
