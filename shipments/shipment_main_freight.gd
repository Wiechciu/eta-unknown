class_name ShipmentMainFreight
extends Resource


var shipment: Shipment
var mode_of_transport: Shipment.ModeOfTransport #TODO
var carrier: Carrier #TODO
var planned_departure_date: int #TODO
var planned_arrival_date: int #TODO
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentMainFreight:
	var new_main_freight := ShipmentMainFreight.new()
	new_main_freight.shipment = parent_shipment
	
	return new_main_freight
