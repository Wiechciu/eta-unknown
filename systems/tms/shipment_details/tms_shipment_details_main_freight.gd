class_name TmsShipmentDetailsMainFreight
extends PanelContainer


var shipment_main_freight: ShipmentMainFreight
@export var mode_of_transport: Label
@export var carrier: Label
@export var planned_departure: Label
@export var planned_arrival: Label

@export var _arrange_button: Button


func refresh() -> void:
	load_shipment(shipment_main_freight)


func load_shipment(shipment_main_freight_to_load: ShipmentMainFreight) -> void:
	shipment_main_freight = shipment_main_freight_to_load
	
	mode_of_transport.text = Shipment.ModeOfTransport.keys()[shipment_main_freight.mode_of_transport] if shipment_main_freight.mode_of_transport != Shipment.ModeOfTransport.NONE else ""
	carrier.text = shipment_main_freight.carrier.name if shipment_main_freight.carrier else ""
	planned_departure.text = GlobalTimer.get_nice_format_datetime_string(shipment_main_freight.planned_departure_date)
	planned_arrival.text = GlobalTimer.get_nice_format_datetime_string(shipment_main_freight.planned_arrival_date)


func _on_arrange_main_freight_button_pressed() -> void:
	shipment_main_freight.mode_of_transport = randi_range(1, 4)
	shipment_main_freight.carrier = Carrier.all_specific_with_employees.pick_random()
	shipment_main_freight.planned_departure_date = GlobalTimer.get_future_date(shipment_main_freight.shipment.earliest_pickup_date, 1, 12, 00)
	shipment_main_freight.planned_arrival_date = GlobalTimer.get_future_date(shipment_main_freight.shipment.latest_delivery_date, -1, 12, 00)
	
	refresh()
