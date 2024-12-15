class_name ShipmentHaulage
extends Resource


var trucker_pickup: Party
var trucker_delivery: Party


@warning_ignore("shadowed_variable")
func with_data(trucker_pickup: Party, trucker_delivery: Party) -> ShipmentHaulage:
	self.trucker_pickup = trucker_pickup
	self.trucker_delivery = trucker_delivery
	
	return self
