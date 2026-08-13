class_name ShipmentEvents
extends Resource


signal events_updated
signal event_registered(event: Event)
signal planned_event_registered(planned_event: Event)
signal actual_event_registered(actual_event: Event)
signal time_event_notification(time_event: TimeEvent)


var shipment: Shipment
var events: Array[Event]
var planned_events: Array[Event]
var actual_events: Array[Event]


@warning_ignore("shadowed_variable")
static func create_new(shipment: Shipment, events: Array[Event]) -> ShipmentEvents:
	var new_shipment_events: ShipmentEvents = ShipmentEvents.new()
	
	# The below is for debugging only for random generated shipments
	new_shipment_events.planned_event_registered.connect(_on_planned_event_registered.bind(shipment))
	new_shipment_events.actual_event_registered.connect(_on_actual_event_registered.bind(shipment))
	new_shipment_events.time_event_notification.connect(_on_time_event_notification.bind(shipment))
	
	new_shipment_events.shipment = shipment
	new_shipment_events.register_events(events)
	
	return new_shipment_events


@warning_ignore("shadowed_variable")
func register_events(events: Array[Event]) -> void:
	for event: Event in events:
		register_event(event)


func register_event(event: Event) -> void:
	if event.type == Event.Type.PLANNED:
		planned_events.append(event)
		planned_events.sort_custom(_sort_ascending)
		planned_event_registered.emit(event)
		GlobalTimer.create_time_event_from_event(event, self)
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


func register_new_planned_event(code: String, time: int, location: Location = null) -> Event:
	var new_event: Event = Event.create_new(code, Event.Type.PLANNED, time, location)
	register_event(new_event)
	return new_event


func register_new_actual_event(code: String, time: int, location: Location = null) -> Event:
	var new_event: Event = Event.create_new(code, Event.Type.ACTUAL, time, location)
	register_event(new_event)
	return new_event


func register_new_actual_event_now(code: String, location: Location = null) -> Event:
	return register_new_actual_event(code, GlobalTimer.now, location)


func register_new_actual_event_from_planned_event(event_planned: Event) -> Event:
	return register_new_actual_event(event_planned.event_data.code, event_planned.time, event_planned.location)


func get_all_events_of_code(code: String) -> Array[Event]:
	return events.filter(func(event: Event) -> bool: return event.event_data.code == code)


func get_first_event_of_code(code: String) -> Event:
	var index: int = events.find_custom(func(event: Event) -> bool: return event.event_data.code == code)
	if index == -1:
		return null
	return events[index]


func get_last_event_of_code(code: String) -> Event:
	var index: int = events.rfind_custom(func(event: Event) -> bool: return event.event_data.code == code)
	if index == -1:
		return null
	return events[index]


func notify(time_event: TimeEvent) -> void:
	time_event_notification.emit(time_event)


func _sort_ascending(a: Event, b: Event) -> bool:
	if a.time < b.time:
		return true
	return false


# The below is for debugging only for random generated shipments
static func _on_planned_event_registered(planned_event: Event, shipment: Shipment) -> void:
	if planned_event.event_data.code == "PUP":
		shipment.change_status(Shipment.Status.PLANNED)
		shipment.accounting.create_new_cost_charge("PUP", randi_range(100, 150), Currency.get_by_code("EUR"), shipment.haulage.trucker_pickup)
		shipment.accounting.create_new_revenue_charge("PUP", randi_range(120, 170), Currency.get_by_code("EUR"), shipment.shipper)
	if planned_event.event_data.code == "DEL":
		shipment.accounting.create_new_cost_charge("DEL", randi_range(100, 150), Currency.get_by_code("EUR"), shipment.haulage.trucker_delivery)
		shipment.accounting.create_new_revenue_charge("DEL", randi_range(120, 170), Currency.get_by_code("EUR"), shipment.consignee)


static func _on_actual_event_registered(actual_event: Event, shipment: Shipment) -> void:
	if actual_event.event_data.code == "PUP":
		shipment.change_status(Shipment.Status.IN_TRANSIT)
	elif actual_event.event_data.code == "DEL":
		shipment.change_status(Shipment.Status.DELIVERED)


static func _on_time_event_notification(time_event: TimeEvent, shipment: Shipment) -> void:
	var event: Event
	for arg: Variant in time_event.args:
		if arg is Event:
			event = arg
			break
		return
	
	print("Shipment ID: %s, number: %s, event: %s at %s" % [shipment.id, shipment.number, event.event_data.code, GlobalTimer.get_nice_datetime_string_from_unix_time(time_event.time)])
	
	if event.event_data.code == "LTS" and not shipment.is_owned:
		shipment.remove()
	
	#TODO: this is to be removed once proper events are created
	if event.event_data.code != "ERL" and event.event_data.code != "LTS":
		shipment.events.register_new_actual_event_from_planned_event(event)
	
	match event.event_data.code:
		"BOK":
			shipment.documentation.create_new_document_now("SPO", 1)
		"PUP":
			shipment.documentation.create_new_document_now("PUO", 1)
		"CSE":
			shipment.documentation.create_new_document_now("CDE", 1)
		"CSI":
			shipment.documentation.create_new_document_now("CDI", 1)
		"DEP" when shipment.main_freight.mode_of_transport != null and shipment.main_freight.mode_of_transport == ModeOfTransport.get_mode_of_transport_by_code("AIR"):
			shipment.documentation.create_new_document_now("HWB", 1)
			shipment.documentation.create_new_document_now("MWB", 1)
		"DEP" when shipment.main_freight.mode_of_transport != null and shipment.main_freight.mode_of_transport == ModeOfTransport.get_mode_of_transport_by_code("AIR"):
			shipment.documentation.create_new_document_now("HBL", 1)
			shipment.documentation.create_new_document_now("MBL", 1)
		"REL":
			shipment.documentation.create_new_document_now("DLO", 1)
		"DEL":
			shipment.documentation.create_new_document_now("POD", 1)
