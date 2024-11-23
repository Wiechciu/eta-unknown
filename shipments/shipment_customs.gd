class_name ShipmentCustoms
extends Resource


var shipment: Shipment
var customs_agency_export: CustomsAgency #TODO
var customs_agency_import: CustomsAgency #TODO
var cost: String #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentCustoms:
	var new_customs := ShipmentCustoms.new()
	new_customs.shipment = parent_shipment
	
	return new_customs
