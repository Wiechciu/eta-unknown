class_name ShipmentHaulage
extends Resource


var trucker_pickup: Party
var trucker_delivery: Party


@warning_ignore("shadowed_variable")
static func create_new(trucker_pickup: Party, trucker_delivery: Party) -> ShipmentHaulage:
	var new_shipment_haulage: ShipmentHaulage = ShipmentHaulage.new()
	new_shipment_haulage.trucker_pickup = trucker_pickup
	new_shipment_haulage.trucker_delivery = trucker_delivery
	
	return new_shipment_haulage
