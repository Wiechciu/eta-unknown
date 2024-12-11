class_name ShipmentHandling
extends Resource


@export_storage var shipment: Shipment
@export_storage var handling_agent_export: HandlingAgent #TODO
@export_storage var handling_agent_import: HandlingAgent #TODO
@export_storage var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentHandling:
	self.shipment = parent_shipment
	return self
