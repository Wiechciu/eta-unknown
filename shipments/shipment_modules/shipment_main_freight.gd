class_name ShipmentMainFreight
extends Resource


@export_storage var shipment: Shipment
@export_storage var mode_of_transport: ModeOfTransport
@export_storage var carrier: Carrier
@export_storage var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentMainFreight:
	self.shipment = parent_shipment
	return self
