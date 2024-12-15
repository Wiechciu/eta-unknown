#class_name EventActual
#extends Event


#var event_planned: EventPlanned


#@warning_ignore("shadowed_variable", "shadowed_variable_base_class")
#func with_data(code: Event.Code, time: int, location: Location = null, event_planned: EventPlanned = null) -> EventActual:
	#self.code = code
	#self.time = time
	#self.location = location
	#self.event_planned = event_planned
	#return self
