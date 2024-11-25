class_name ShipmentAccounting
extends Resource


var shipment: Shipment
var quotation: Quotation #TODO
var revenue: String #TODO
var cost: String #TODO
var profit: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentAccounting:
	self.shipment = parent_shipment
	return self
