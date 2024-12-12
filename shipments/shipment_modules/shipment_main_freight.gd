class_name ShipmentMainFreight
extends Resource


@export_storage var mode_of_transport: ModeOfTransport
@export_storage var carrier: Carrier


@warning_ignore("shadowed_variable")
func with_data(mode_of_transport: ModeOfTransport, carrier: Carrier) -> ShipmentMainFreight:
	self.mode_of_transport = mode_of_transport
	self.carrier = carrier
	
	return self
