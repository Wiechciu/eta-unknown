class_name ShipmentHandling
extends Resource


var handling_agent_export: Party #TODO
var handling_agent_import: Party #TODO


@warning_ignore("shadowed_variable")
static func create_new(handling_agent_export: Party, handling_agent_import: Party) -> ShipmentHandling:
	var new_shipment_handling: ShipmentHandling = ShipmentHandling.new()
	new_shipment_handling.handling_agent_export = handling_agent_export
	new_shipment_handling.handling_agent_import = handling_agent_import
	
	return new_shipment_handling
