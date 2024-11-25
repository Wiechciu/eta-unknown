class_name EventActual
extends Event


var event_planned: EventPlanned


func with_data(code_to_assign: Event.Code, time_to_assign: int, location_to_assign: Location = null, event_planned_to_assign: EventPlanned = null) -> EventActual:
	self.code = code_to_assign
	self.time = time_to_assign
	self.location = location_to_assign
	self.event_planned = event_planned_to_assign
	return self
