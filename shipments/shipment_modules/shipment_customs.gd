class_name ShipmentCustoms
extends Resource


var shipment: Shipment
var customs_agency_export: CustomsAgency #TODO
var customs_agency_import: CustomsAgency #TODO
var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentCustoms:
	self.shipment = parent_shipment
	return self
