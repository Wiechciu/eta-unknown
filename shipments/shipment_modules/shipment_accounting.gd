class_name ShipmentAccounting
extends Resource


var shipment: Shipment
var quotation: Quotation #TODO
var revenue: String #TODO
var cost: String #TODO
var profit: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentAccounting:
	var new_accounting := ShipmentAccounting.new()
	new_accounting.shipment = parent_shipment
	
	return new_accounting
