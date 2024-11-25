class_name EventPlanned
extends Event


func with_data(code_to_assign: Event.Code, time_to_assign: int, location_to_assign: Location = null) -> EventPlanned:
	self.code = code_to_assign
	self.time = time_to_assign
	self.location = location_to_assign
	return self
