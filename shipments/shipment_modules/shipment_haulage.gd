class_name ShipmentHaulage
extends Resource


@export_storage var trucker_pickup: Trucker
@export_storage var trucker_delivery: Trucker


@warning_ignore("shadowed_variable")
func with_data(trucker_pickup: Trucker, trucker_delivery: Trucker) -> ShipmentHaulage:
	self.trucker_pickup = trucker_pickup
	self.trucker_delivery = trucker_delivery
	
	return self
