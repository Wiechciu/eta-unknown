class_name ShipmentHaulage
extends Resource


var shipment: Shipment
var trucker_pickup: Trucker #TODO
var trucker_delivery: Trucker #TODO
var planned_pickup_date: int #TODO
var planned_delivery_date: int #TODO
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentHaulage:
	var new_haulage := ShipmentHaulage.new()
	new_haulage.shipment = parent_shipment
	
	return new_haulage
