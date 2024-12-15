class_name ShipmentEvents
extends Resource


signal events_updated
signal event_registered(event: Event)
signal planned_event_registered(planned_event: Event)
signal actual_event_registered(actual_event: Event)
signal time_event_notification(time_event: TimeEvent)


@export_storage var events: Array[Event]
@export_storage var planned_events: Array[Event]
@export_storage var actual_events: Array[Event]
#var planned_events_as_events: Array[Event]:
	#get:
		#var new_list: Array[Event]
		#new_list.assign(planned_events)
		#return new_list
#var actual_events_as_events: Array[Event]:
	#get:
		#var new_list: Array[Event]
		#new_list.assign(actual_events)
		#return new_list


@warning_ignore("shadowed_variable")
func with_data(events: Array[Event]) -> ShipmentEvents:
	register_events(events)
	
	return self


@warning_ignore("shadowed_variable")
func register_events(events: Array[Event]) -> void:
	for event: Event in events:
		register_event(event)


func register_event(event: Event) -> void:
	if event.type == Event.Type.PLANNED:
		planned_events.append(event)
		planned_events.sort_custom(_sort_ascending)
		planned_event_registered.emit(event)
	elif event.type == Event.Type.ACTUAL:
		actual_events.append(event)
		actual_events.sort_custom(_sort_ascending)
		actual_event_registered.emit(event)
	events.append(event)
	events.sort_custom(_sort_ascending)
	event_registered.emit(event)
	events_updated.emit()


func remove_event(event: Event) -> void:
	events.erase(event)
	if event.type == Event.Type.PLANNED:
		planned_events.erase(event)
	elif event.type == Event.Type.ACTUAL:
		actual_events.erase(event)
	events_updated.emit()


func create_new_planned_event(code: Event.Code, time: int, location: Location = null) -> Event:
	var new_event: Event = Event.new().with_data(code, Event.Type.PLANNED, time, location)
	@warning_ignore("unsafe_method_access")
	GlobalTimer.create_time_event_from_event(new_event, self)
	register_event(new_event)
	return new_event


func create_new_actual_event(code: Event.Code, time: int, location: Location = null) -> Event:
	var new_event: Event = Event.new().with_data(code, Event.Type.ACTUAL, time, location)
	register_event(new_event)
	return new_event


func create_new_actual_event_now(code: Event.Code, location: Location = null) -> Event:
	@warning_ignore("unsafe_property_access", "unsafe_call_argument")
	return create_new_actual_event(code, GlobalTimer.now, location)


func create_new_actual_event_from_planned_event(event_planned: Event) -> Event:
	return create_new_actual_event(event_planned.code, event_planned.time, event_planned.location)


func get_all_events_of_code(code: Event.Code) -> Array[Event]:
	return events.filter(func(event: Event) -> bool: return event.code == code)


func get_first_event_of_code(code: Event.Code) -> Event:
	var index: int = events.find_custom(func(event: Event) -> bool: return event.code == code)
	if index == -1:
		return null
	return events[index]


func get_last_event_of_code(code: Event.Code) -> Event:
	var index: int = events.rfind_custom(func(event: Event) -> bool: return event.code == code)
	if index == -1:
		return null
	return events[index]


func notify(time_event: TimeEvent) -> void:
	time_event_notification.emit(time_event)


func _sort_ascending(a: Event, b: Event) -> bool:
	if a.time < b.time:
		return true
	return false
