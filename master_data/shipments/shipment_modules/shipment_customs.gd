class_name ShipmentCustoms
extends Resource


var customs_agency_export: Party #TODO
var customs_agency_import: Party #TODO


@warning_ignore("shadowed_variable")
func with_data(customs_agency_export: Party, customs_agency_import: Party) -> ShipmentCustoms:
	self.customs_agency_export = customs_agency_export
	self.customs_agency_import = customs_agency_import
	
	return self
