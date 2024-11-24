class_name ShipmentMainFreight
extends Resource


var shipment: Shipment
var mode_of_transport: ModeOfTransport
var carrier: Carrier
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentMainFreight:
	var new_main_freight := ShipmentMainFreight.new()
	new_main_freight.shipment = parent_shipment
	
	return new_main_freight
