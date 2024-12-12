class_name ShipmentHandling
extends Resource


@export_storage var handling_agent_export: HandlingAgent #TODO
@export_storage var handling_agent_import: HandlingAgent #TODO


@warning_ignore("shadowed_variable")
func with_data(handling_agent_export: HandlingAgent, handling_agent_import: HandlingAgent) -> ShipmentHandling:
	self.handling_agent_export = handling_agent_export
	self.handling_agent_import = handling_agent_import
	
	return self
