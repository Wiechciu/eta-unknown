class_name TmsShipmentDetailsHaulage
extends PanelContainer


var shipment_haulage: ShipmentHaulage
@export var trucker_pickup: Label
@export var trucker_delivery: Label
@export var planned_pickup: Label
@export var planned_delivery: Label

@export var _arrange_pickup_button: Button
@export var _arrange_delivery_button: Button


func refresh() -> void:
	load_shipment(shipment_haulage)


func load_shipment(shipment_haulage_to_load: ShipmentHaulage) -> void:
	shipment_haulage = shipment_haulage_to_load
	
	trucker_pickup.text = shipment_haulage.trucker_pickup.name if shipment_haulage.trucker_pickup else ""
	trucker_delivery.text = shipment_haulage.trucker_delivery.name if shipment_haulage.trucker_delivery else ""
	planned_pickup.text = GlobalTimer.get_nice_format_datetime_string(shipment_haulage.planned_pickup_date)
	planned_delivery.text = GlobalTimer.get_nice_format_datetime_string(shipment_haulage.planned_delivery_date)


func _on_arrange_pickup_button_pressed() -> void:
	shipment_haulage.trucker_pickup = Trucker.all_specific_with_employees.pick_random()
	shipment_haulage.planned_pickup_date = GlobalTimer.get_future_date(shipment_haulage.shipment.earliest_pickup_date, 0, 12, 00)
	
	refresh()


func _on_arrange_delivery_button_pressed() -> void:
	shipment_haulage.trucker_delivery = Trucker.all_specific_with_employees.pick_random()
	shipment_haulage.planned_delivery_date = GlobalTimer.get_future_date(shipment_haulage.shipment.latest_delivery_date, 0, 8, 00)
	
	refresh()
