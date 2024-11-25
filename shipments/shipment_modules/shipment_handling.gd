class_name ShipmentHandling
extends Resource


var shipment: Shipment
var handling_agent_export: HandlingAgent #TODO
var handling_agent_import: HandlingAgent #TODO
var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentHandling:
	self.shipment = parent_shipment
	return self
