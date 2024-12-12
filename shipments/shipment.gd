class_name Shipment
extends Resource


signal details_changed(shipment: Shipment)
signal status_changed(shipment: Shipment)
signal completed(shipment: Shipment)


enum Status {
	REQUESTED,
	QUOTED,
	ACCEPTED,
	PLANNED,
	IN_TRANSIT,
	DELIVERED,
	INVOICED,
	COMPLETED,
	CANCELLED,
}


@export_storage var id: int
@export_storage var status: Status
var is_completed_or_cancelled: bool:
	get:
		return status == Status.COMPLETED or status == Status.CANCELLED

# General
@export_storage var customer_reference: String
@export_storage var export_contact_person: Person
@export_storage var import_contact_person: Person
@export_storage var shipper: Party
@export_storage var consignee: Party
@export_storage var origin: Location
@export_storage var destination: Location
@export_storage var service: Service
@export_storage var incoterms: Incoterms

# Accepted shipment variables
@export_storage var number: int
@export_storage var owner: FreightForwarder
var is_owned: bool:
	get:
		return owner != null

# Shipment modules
@export_storage var cargo_details: ShipmentCargoDetails
@export_storage var main_freight: ShipmentMainFreight
@export_storage var haulage: ShipmentHaulage
@export_storage var handling: ShipmentHandling
@export_storage var customs: ShipmentCustoms
@export_storage var documentation: ShipmentDocumentation
@export_storage var events: ShipmentEvents
@export_storage var accounting: ShipmentAccounting


func with_data(shipper_to_assign: Customer = null, consignee_to_assign: Customer = null) -> Shipment:
	@warning_ignore("unsafe_method_access")
	id = GlobalRefs.get_shipment_id()
	
	cargo_details = ShipmentCargoDetails.new().with_data_random()
	main_freight = ShipmentMainFreight.new()
	haulage = ShipmentHaulage.new()
	handling = ShipmentHandling.new()
	customs = ShipmentCustoms.new()
	documentation = ShipmentDocumentation.new()
	events = ShipmentEvents.new()
	accounting = ShipmentAccounting.new()
	
	events.planned_event_registered.connect(_on_planned_event_registered)
	events.actual_event_registered.connect(_on_actual_event_registered)
	events.time_event_notification.connect(_on_time_event_notification)
	
	customer_reference = generate_random_customer_reference(randi_range(3, 5), randi_range(3, 5))
	
	if shipper_to_assign == null:
		@warning_ignore("unsafe_property_access", "unsafe_method_access")
		shipper_to_assign = GlobalRefs.customers_with_employees.pick_random()
	shipper = shipper_to_assign
	if consignee_to_assign == null:
		@warning_ignore("unsafe_property_access", "unsafe_method_access")
		consignee_to_assign = GlobalRefs.customers_with_employees.pick_random()
	consignee = consignee_to_assign
	#FIXME make it always be in a different country.
	if shipper.country == consignee.country:
		return null
	
	export_contact_person = shipper.employees.pick_random()
	import_contact_person = consignee.employees.pick_random()
	
	var origin_list: Array[Location] = shipper.country.locations
	var destination_list: Array[Location] = consignee.country.locations
	#FIXME sometimes origin or destination can be empty, because there are no locations in the customer country.
	if origin_list.is_empty() or destination_list.is_empty():
		return null

	@warning_ignore("unsafe_cast")
	origin = origin_list.pick_random() as Location
	@warning_ignore("unsafe_cast")
	destination = destination_list.pick_random() as Location
	
	@warning_ignore("unsafe_method_access", "unsafe_call_argument")
	events.create_new_planned_event(Event.Code.ERL, GlobalTimer.get_future_date_from_now(randi_range(1, 20), 10, 0))
	@warning_ignore("unsafe_method_access", "unsafe_call_argument")
	events.create_new_planned_event(Event.Code.LTS, GlobalTimer.get_future_date_from_event(events.get_first_event_of_type(Event.Code.ERL), randi_range(2, 30), 17, 0))
	
	service = Service.new().with_data_random()
	incoterms = Incoterms.new().with_data_random()
	var incoterms_location: String
	match incoterms.group:
		"C", "D":
			incoterms_location = consignee.city_name
		"E", "F":
			incoterms_location = shipper.city_name
	incoterms.place = incoterms_location
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.shipments.append(self)
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	print("New shipment created. Shipment ID: %s. There are %s active shipments." % [id, GlobalRefs.shipments.size()])
	return self


func load_saved_data(shipment: Shipment) -> Shipment:
	self.id = shipment.id
	self.status = shipment.status
	self.customer_reference = shipment.customer_reference
	self.export_contact_person = GlobalRefs.people[shipment.export_contact_person.id] if shipment.export_contact_person else null
	self.import_contact_person = GlobalRefs.people[shipment.import_contact_person.id] if shipment.import_contact_person else null
	self.shipper = GlobalRefs.parties[shipment.shipper.id] if shipment.shipper else null
	self.consignee = GlobalRefs.parties[shipment.consignee.id] if shipment.consignee else null
	self.origin = GlobalRefs.locations[shipment.origin.id] if shipment.origin else null
	self.destination = GlobalRefs.locations[shipment.destination.id] if shipment.destination else null
	self.service = Service.new().with_data(shipment.service.code) if shipment.service else null
	self.incoterms = Incoterms.new().with_data(shipment.incoterms.code, shipment.incoterms.place) if shipment.incoterms else null
	
	self.number = shipment.number
	self.owner = GlobalRefs.freight_forwarders[shipment.owner.id] if shipment.owner else null
	
	self.cargo_details = ShipmentCargoDetails.new().with_data(shipment.cargo_details.cargo, shipment.cargo_details.dimension_sets)
	self.main_freight = ShipmentMainFreight.new().with_data(shipment.main_freight.mode_of_transport, shipment.main_freight.carrier)
	self.haulage = ShipmentHaulage.new().with_data(shipment.haulage.trucker_pickup, shipment.haulage.trucker_delivery)
	self.handling = ShipmentHandling.new().with_data(shipment.handling.handling_agent_export, shipment.handling.handling_agent_import)
	self.customs = ShipmentCustoms.new().with_data(shipment.customs.customs_agency_export, shipment.customs.customs_agency_import)
	self.documentation = ShipmentDocumentation.new().with_data(shipment.documentation.documents)
	self.events = ShipmentEvents.new().with_data(shipment.events.events)
	self.accounting = ShipmentAccounting.new().with_data(shipment.accounting.quotation, shipment.accounting.charges)
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.shipments.append(self)
	
	return self


func remove() -> void:
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.shipments.erase(self)


func generate_random_customer_reference(string_length: int, number_length: int) -> String:
	var random_customer_reference: String = ""
	var allowed_characters_in_string: String = "abcdefghijklmnopqrstvwxyz"
	var allowed_characters_in_number: String = "1234567890"
	var number_of_characters: int = 0
	
	number_of_characters = len(allowed_characters_in_string)
	for i: int in range(string_length):
		random_customer_reference += allowed_characters_in_string[randi()% number_of_characters].to_upper()
	
	number_of_characters = len(allowed_characters_in_number)
	for i: int in range(number_length):
		random_customer_reference += allowed_characters_in_number[randi()% number_of_characters]
	
	return random_customer_reference


func accept(new_owner: FreightForwarder) -> void:
	events.create_new_actual_event_now(Event.Code.BOK)
	change_status(Status.ACCEPTED)
	owner = new_owner
	number = owner.get_next_shipment_number()
	new_owner.accept_shipment(self)


func change_status(new_status: Status) -> void:
	# This prevents the status to be changed from Cancelled
	#if status > new_status:
		#return
	
	status = new_status
	if status == Status.COMPLETED:
		completed.emit(self)
	status_changed.emit(self)
	details_changed.emit(self)


func notify_details_changed() -> void:
	details_changed.emit()


func _on_planned_event_registered(planned_event: EventPlanned) -> void:
	if planned_event.code == Event.Code.PUP:
		change_status(Shipment.Status.PLANNED)
		@warning_ignore("unsafe_property_access", "unsafe_call_argument")
		accounting.create_new_cost_charge(Charge.Code.PUP, randi_range(100, 150), GlobalRefs.currencies_dict["EUR"], haulage.trucker_pickup)
		@warning_ignore("unsafe_property_access", "unsafe_call_argument")
		accounting.create_new_revenue_charge(Charge.Code.PUP, randi_range(120, 170), GlobalRefs.currencies_dict["EUR"], shipper)
	if planned_event.code == Event.Code.DEL:
		@warning_ignore("unsafe_property_access", "unsafe_call_argument")
		accounting.create_new_cost_charge(Charge.Code.DEL, randi_range(100, 150), GlobalRefs.currencies_dict["EUR"], haulage.trucker_delivery)
		@warning_ignore("unsafe_property_access", "unsafe_call_argument")
		accounting.create_new_revenue_charge(Charge.Code.DEL, randi_range(120, 170), GlobalRefs.currencies_dict["EUR"], consignee)


func _on_actual_event_registered(actual_event: EventActual) -> void:
	if actual_event.code == Event.Code.PUP:
		change_status(Shipment.Status.IN_TRANSIT)
	elif actual_event.code == Event.Code.DEL:
		change_status(Shipment.Status.DELIVERED)


func _on_time_event_notification(time_event: TimeEvent) -> void:
	@warning_ignore("unsafe_method_access")
	print("Shipment ID: %s, number: %s, event: %s at %s" % [id, number, time_event.event.code_string, GlobalTimer.get_nice_datetime_string_from_unix_time(time_event.time)])
	
	if time_event.event.code == Event.Code.LTS and not is_owned:
		remove()
	
	#TODO: this is to be removed once proper events are created
	if time_event.event.code != Event.Code.ERL and time_event.event.code != Event.Code.LTS:
		events.create_new_actual_event_from_planned_event(time_event.event as EventPlanned)
	
	match time_event.event.code:
		Event.Code.BOK:
			documentation.create_new_document_now(Document.Code.SPO, 1)
		Event.Code.PUP:
			documentation.create_new_document_now(Document.Code.PUO, 1)
		Event.Code.CSE:
			documentation.create_new_document_now(Document.Code.CDE, 1)
		Event.Code.CSI:
			documentation.create_new_document_now(Document.Code.CDI, 1)
		Event.Code.DEP when main_freight.mode_of_transport != null and main_freight.mode_of_transport.code == ModeOfTransport.Code.AIR:
			documentation.create_new_document_now(Document.Code.HWB, 1)
			documentation.create_new_document_now(Document.Code.MWB, 1)
		Event.Code.DEP when main_freight.mode_of_transport != null and main_freight.mode_of_transport.code == ModeOfTransport.Code.SEA:
			documentation.create_new_document_now(Document.Code.HBL, 1)
			documentation.create_new_document_now(Document.Code.MBL, 1)
		Event.Code.REL:
			documentation.create_new_document_now(Document.Code.DLO, 1)
		Event.Code.DEL:
			documentation.create_new_document_now(Document.Code.POD, 1)
