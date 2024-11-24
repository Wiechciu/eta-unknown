class_name ShipmentEvents
extends Resource


signal events_updated


var shipment: Shipment
var events: Array[Event]
var planned_events: Array[EventPlanned]
var planned_events_as_events: Array[Event]:
	get:
		var new_list: Array[Event]
		new_list.assign(planned_events)
		return new_list
var actual_events: Array[EventActual]
var actual_events_as_events: Array[Event]:
	get:
		var new_list: Array[Event]
		new_list.assign(actual_events)
		return new_list


static func create_new(parent_shipment: Shipment) -> ShipmentEvents:
	var new_events := ShipmentEvents.new()
	new_events.shipment = parent_shipment
	return new_events


func create_new_planned_event(code: Event.Code, time: int, location: Location = null) -> EventPlanned:
	var new_event := EventPlanned.new().with_data(code, time, location)
	events.append(new_event)
	events.sort_custom(_sort_events_ascending)
	planned_events.append(new_event)
	planned_events.sort_custom(_sort_events_ascending)
	GlobalTimer.create_time_event_from_event(new_event, self)
	
	if new_event.code == Event.Code.PUP:
		shipment.change_status(Shipment.Status.PLANNED)
	
	events_updated.emit()
	return new_event


func create_new_actual_event(code: Event.Code, time: int, location: Location = null, event_planned: EventPlanned = null) -> EventActual:
	var new_event := EventActual.new().with_data(code, time, location, event_planned)
	events.append(new_event)
	events.sort_custom(_sort_events_ascending)
	actual_events.append(new_event)
	actual_events.sort_custom(_sort_events_ascending)
	
	if new_event.code == Event.Code.PUP:
		shipment.change_status(Shipment.Status.IN_TRANSIT)
	if new_event.code == Event.Code.DEL:
		shipment.change_status(Shipment.Status.DELIVERED)
	
	events_updated.emit()
	return new_event


func create_new_actual_event_now(code: Event.Code, location: Location = null, event_planned: EventPlanned = null) -> EventActual:
	return create_new_actual_event(code, GlobalTimer.now, location, event_planned)


func create_new_actual_event_from_planned_event(event_planned: EventPlanned) -> EventActual:
	return create_new_actual_event(event_planned.code, event_planned.time, event_planned.location, event_planned)


func get_all_events_of_type(code: Event.Code) -> Array[Event]:
	return events.filter(func(event: Event): return event.code == code)


func get_first_event_of_type(code: Event.Code) -> Event:
	var index := events.find_custom(func(event: Event): return event.code == code)
	if index == -1:
		return null
	return events[index]


func get_last_event_of_type(code: Event.Code) -> Event:
	var index := events.rfind_custom(func(event: Event): return event.code == code)
	if index == -1:
		return null
	return events[index]


func notify(time_event: TimeEvent) -> void:
	print_debug("Shipment ID: %s, number: %s, event: %s at %s" % [shipment.shipment_id, shipment.shipment_number, time_event.event.code_string, GlobalTimer.get_nice_datetime_string_from_unix_time(time_event.time)])
	if time_event.event.code != Event.Code.ERL and time_event.event.code != Event.Code.LTS:
		create_new_actual_event_from_planned_event(time_event.event as EventPlanned)


func _sort_events_ascending(a: Event, b: Event) -> bool:
	if a.time < b.time:
		return true
	return false
