class_name ShipmentMainFreight
extends Resource


var mode_of_transport: ModeOfTransport
var carrier: Party


@warning_ignore("shadowed_variable")
static func create_new(mode_of_transport: ModeOfTransport, carrier: Party) -> ShipmentMainFreight:
	var new_shipment_main_freight: ShipmentMainFreight = ShipmentMainFreight.new()
	new_shipment_main_freight.mode_of_transport = mode_of_transport
	new_shipment_main_freight.carrier = carrier
	
	return new_shipment_main_freight
