class_name ShipmentCustoms
extends Resource


@export_storage var customs_agency_export: CustomsAgency #TODO
@export_storage var customs_agency_import: CustomsAgency #TODO


@warning_ignore("shadowed_variable")
func with_data(customs_agency_export: CustomsAgency, customs_agency_import: CustomsAgency) -> ShipmentCustoms:
	self.customs_agency_export = customs_agency_export
	self.customs_agency_import = customs_agency_import
	
	return self
