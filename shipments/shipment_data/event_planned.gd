class_name EventPlanned
extends Event


func with_data(code: Event.Code, time: int, location: Location = null) -> EventPlanned:
	self.code = code
	self.time = time
	self.location = location
	return self
