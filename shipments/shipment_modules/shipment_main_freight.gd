class_name ShipmentMainFreight
extends Resource


var mode_of_transport: ModeOfTransport
var carrier: Party


@warning_ignore("shadowed_variable")
func with_data(mode_of_transport: ModeOfTransport, carrier: Party) -> ShipmentMainFreight:
	self.mode_of_transport = mode_of_transport
	self.carrier = carrier
	
	return self
