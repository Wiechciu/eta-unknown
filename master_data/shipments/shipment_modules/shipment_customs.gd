class_name ShipmentCustoms
extends Resource


var shipment: Shipment
var customs_agency_export: Party #TODO
var customs_agency_import: Party #TODO


@warning_ignore("shadowed_variable")
static func create_new(customs_agency_export: Party, customs_agency_import: Party) -> ShipmentCustoms:
	var new_shipment_customs: ShipmentCustoms = ShipmentCustoms.new()
	new_shipment_customs.customs_agency_export = customs_agency_export
	new_shipment_customs.customs_agency_import = customs_agency_import
	
	return new_shipment_customs
