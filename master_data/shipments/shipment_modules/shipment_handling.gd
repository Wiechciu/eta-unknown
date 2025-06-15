class_name ShipmentHandling
extends Resource


var handling_agent_export: Party #TODO
var handling_agent_import: Party #TODO


@warning_ignore("shadowed_variable")
func with_data(handling_agent_export: Party, handling_agent_import: Party) -> ShipmentHandling:
	self.handling_agent_export = handling_agent_export
	self.handling_agent_import = handling_agent_import
	
	return self
