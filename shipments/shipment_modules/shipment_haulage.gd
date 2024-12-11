class_name ShipmentHaulage
extends Resource


@export_storage var shipment: Shipment
@export_storage var trucker_pickup: Trucker
@export_storage var trucker_delivery: Trucker
@export_storage var cost: String #TODO


func with_data(parent_shipment: Shipment) -> ShipmentHaulage:
	self.shipment = parent_shipment
	return self
