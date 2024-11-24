class_name ShipmentHandling
extends Resource


var shipment: Shipment
var handling_agent_export: HandlingAgent #TODO
var handling_agent_import: HandlingAgent #TODO
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentHandling:
	var new_handling := ShipmentHandling.new()
	new_handling.shipment = parent_shipment
	
	return new_handling
