class_name ShipmentHaulage
extends Resource


var shipment: Shipment
var trucker_pickup: Trucker
var trucker_delivery: Trucker
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentHaulage:
	var new_haulage := ShipmentHaulage.new()
	new_haulage.shipment = parent_shipment
	
	return new_haulage
