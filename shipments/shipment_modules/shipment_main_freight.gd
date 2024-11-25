class_name ShipmentMainFreight
extends Resource


var shipment: Shipment
var mode_of_transport: ModeOfTransport
var carrier: Carrier
var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentMainFreight:
	self.shipment = parent_shipment
	return self
