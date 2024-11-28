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


func with_data(parent_shipment: Shipment) -> ShipmentEvents:
	self.shipment = parent_shipment
	return self


func register_event(event: Event) -> void:
	events.append(event)
	events.sort_custom(_sort_ascending)
	if event is EventPlanned:
		planned_events.append(event)
		planned_events.sort_custom(_sort_ascending)
	elif event is EventActual:
		actual_events.append(event)
		actual_events.sort_custom(_sort_ascending)
	
	if event.code == Event.Code.PUP and event is EventPlanned:
		shipment.change_status(Shipment.Status.PLANNED)
		shipment.accounting.create_new_cost_charge(Charge.Code.PUP, randi_range(100, 150), GlobalRefs.currencies_dict["EUR"], shipment.haulage.trucker_pickup)
		shipment.accounting.create_new_revenue_charge(Charge.Code.PUP, randi_range(120, 170), GlobalRefs.currencies_dict["EUR"], shipment.shipper)
	if event.code == Event.Code.DEL and event is EventPlanned:
		shipment.accounting.create_new_cost_charge(Charge.Code.DEL, randi_range(100, 150), GlobalRefs.currencies_dict["EUR"], shipment.haulage.trucker_delivery)
		shipment.accounting.create_new_revenue_charge(Charge.Code.DEL, randi_range(120, 170), GlobalRefs.currencies_dict["EUR"], shipment.consignee)
	elif event.code == Event.Code.PUP and event is EventActual:
		shipment.change_status(Shipment.Status.IN_TRANSIT)
	elif event.code == Event.Code.DEL and event is EventActual:
		shipment.change_status(Shipment.Status.DELIVERED)
	
	events_updated.emit()


func remove_event(event: Event) -> void:
	events.erase(event)
	if event is EventPlanned:
		planned_events.erase(event)
	elif event is EventActual:
		actual_events.erase(event)
	events_updated.emit()


func create_new_planned_event(code: Event.Code, time: int, location: Location = null) -> EventPlanned:
	var new_event: EventPlanned = EventPlanned.new().with_data(code, time, location)
	GlobalTimer.create_time_event_from_event(new_event, self)
	register_event(new_event)
	return new_event


func create_new_actual_event(code: Event.Code, time: int, location: Location = null, event_planned: EventPlanned = null) -> EventActual:
	var new_event: EventActual = EventActual.new().with_data(code, time, location, event_planned)
	register_event(new_event)
	return new_event


func create_new_actual_event_now(code: Event.Code, location: Location = null, event_planned: EventPlanned = null) -> EventActual:
	return create_new_actual_event(code, GlobalTimer.now, location, event_planned)


func create_new_actual_event_from_planned_event(event_planned: EventPlanned) -> EventActual:
	return create_new_actual_event(event_planned.code, event_planned.time, event_planned.location, event_planned)


func get_all_events_of_type(code: Event.Code) -> Array[Event]:
	return events.filter(func(event: Event) -> bool: return event.code == code)


func get_first_event_of_type(code: Event.Code) -> Event:
	var index: int = events.find_custom(func(event: Event) -> bool: return event.code == code)
	if index == -1:
		return null
	return events[index]


func get_last_event_of_type(code: Event.Code) -> Event:
	var index: int = events.rfind_custom(func(event: Event) -> bool: return event.code == code)
	if index == -1:
		return null
	return events[index]


func notify(time_event: TimeEvent) -> void:
	print("Shipment ID: %s, number: %s, event: %s at %s" % [shipment.shipment_id, shipment.number, time_event.event.code_string, GlobalTimer.get_nice_datetime_string_from_unix_time(time_event.time)])
	
	if time_event.event.code == Event.Code.LTS and not shipment.is_owned:
		shipment.remove()
	
	#TODO: this is to be removed once proper events are created
	if time_event.event.code != Event.Code.ERL and time_event.event.code != Event.Code.LTS:
		create_new_actual_event_from_planned_event(time_event.event as EventPlanned)
	
	match time_event.event.code:
		Event.Code.BOK:
			shipment.documentation.create_new_document_now(Document.Code.SPO, 1)
		Event.Code.PUP:
			shipment.documentation.create_new_document_now(Document.Code.PUO, 1)
		Event.Code.CSE:
			shipment.documentation.create_new_document_now(Document.Code.CDE, 1)
		Event.Code.CSI:
			shipment.documentation.create_new_document_now(Document.Code.CDI, 1)
		Event.Code.DEP when shipment.main_freight.mode_of_transport != null and shipment.main_freight.mode_of_transport.code == ModeOfTransport.Code.AIR:
			shipment.documentation.create_new_document_now(Document.Code.HWB, 1)
			shipment.documentation.create_new_document_now(Document.Code.MWB, 1)
		Event.Code.DEP when shipment.main_freight.mode_of_transport != null and shipment.main_freight.mode_of_transport.code == ModeOfTransport.Code.SEA:
			shipment.documentation.create_new_document_now(Document.Code.HBL, 1)
			shipment.documentation.create_new_document_now(Document.Code.MBL, 1)
		Event.Code.REL:
			shipment.documentation.create_new_document_now(Document.Code.DLO, 1)
		Event.Code.DEL:
			shipment.documentation.create_new_document_now(Document.Code.POD, 1)


func _sort_ascending(a: Event, b: Event) -> bool:
	if a.time < b.time:
		return true
	return false
