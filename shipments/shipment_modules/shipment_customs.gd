class_name ShipmentCustoms
extends Resource


@export_storage var shipment: Shipment
@export_storage var customs_agency_export: CustomsAgency #TODO
@export_storage var customs_agency_import: CustomsAgency #TODO
@export_storage var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentCustoms:
	self.shipment = parent_shipment
	return self
