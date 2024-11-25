class_name ShipmentHaulage
extends Resource


var shipment: Shipment
var trucker_pickup: Trucker
var trucker_delivery: Trucker
var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentHaulage:
	self.shipment = parent_shipment
	return self
