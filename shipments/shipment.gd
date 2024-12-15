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


func with_data(id: int, status: Status, customer_reference: String, export_contact_person: Person, import_contact_person: Person, shipper: Party, consignee: Party, origin: Location, destination: Location, service: Service, incoterms: Incoterms, number: int, owner: FreightForwarder, cargo: Cargo, dimension_sets: Array[DimensionSet], mode_of_transport: ModeOfTransport, carrier: Carrier, trucker_pickup: Trucker, trucker_delivery: Trucker, handling_agent_export: HandlingAgent, handling_agent_import: HandlingAgent, customs_agency_export: CustomsAgency, customs_agency_import: CustomsAgency, documents: Array[Document], events: Array[Event], quotation: Quotation, charges: Array[Charge]) -> Shipment:
	self.id = id
	self.status = status
	self.customer_reference = customer_reference
	self.export_contact_person = export_contact_person
	self.import_contact_person = import_contact_person
	self.shipper = shipper
	self.consignee = consignee
	self.origin = origin
	self.destination = destination
	self.service = service
	self.incoterms = incoterms
	
	self.number = number
	self.owner = owner
	
	self.cargo_details = ShipmentCargoDetails.new().with_data(cargo, dimension_sets)
	self.main_freight = ShipmentMainFreight.new().with_data(mode_of_transport, carrier)
	self.haulage = ShipmentHaulage.new().with_data(trucker_pickup, trucker_delivery)
	self.handling = ShipmentHandling.new().with_data(handling_agent_export, handling_agent_import)
	self.customs = ShipmentCustoms.new().with_data(customs_agency_export, customs_agency_import)
	self.documentation = ShipmentDocumentation.new().with_data(documents)
	self.events = ShipmentEvents.new().with_data(events)
	self.accounting = ShipmentAccounting.new().with_data(quotation, charges)
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.shipments.append(self)
	
	return self


func with_data_random(shipper_to_assign: Customer = null, consignee_to_assign: Customer = null) -> Shipment:
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
	events.create_new_planned_event(Event.Code.LTS, GlobalTimer.get_future_date_from_event(events.get_first_event_of_code(Event.Code.ERL), randi_range(2, 30), 17, 0))
	
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


func _on_planned_event_registered(planned_event: Event) -> void:
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


func _on_actual_event_registered(actual_event: Event) -> void:
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
		events.create_new_actual_event_from_planned_event(time_event.event)
	
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


func to_dict() -> Dictionary:
	var dimension_sets: Array[Dictionary]
	for dimension_set: DimensionSet in cargo_details.dimension_sets:
		dimension_sets.append(dimension_set.to_dict())
	
	return {
		"id" = id,
		"status" = status,
		"customer_reference" = customer_reference,
		"export_contact_person_id" = export_contact_person.id if export_contact_person else "",
		"import_contact_person_id" = import_contact_person.id if import_contact_person else "",
		"shipper_id" = shipper.id if shipper else "",
		"consignee_id" = consignee.id if consignee else "",
		"origin_id" = origin.id if origin else "",
		"destination_id" = destination.id if destination else "",
		"service_code" = service.code if service else "",
		"incoterms_code" = incoterms.code if incoterms else "",
		"incoterms_place" = incoterms.place if incoterms else "",
		"number" = number,
		"owner_id" = owner.id if owner else "",
		"cargo_id" = cargo_details.cargo.id if cargo_details.cargo else "",
		"dimension_sets" = DimensionSet.array_to_dict(cargo_details.dimension_sets),
		"mode_of_transport_code" = main_freight.mode_of_transport.code if main_freight.mode_of_transport else "",
		"carrier_id" = main_freight.carrier.id if main_freight.carrier else "",
		"trucker_pickup_id" = haulage.trucker_pickup.id if haulage.trucker_pickup else "",
		"trucker_delivery_id" = haulage.trucker_delivery.id if haulage.trucker_delivery else "",
		"handling_agent_export_id" = handling.handling_agent_export.id if handling.handling_agent_export else "",
		"handling_agent_import_id" = handling.handling_agent_import.id if handling.handling_agent_import else "",
		"customs_agency_export_id" = customs.customs_agency_export.id if customs.customs_agency_export else "",
		"customs_agency_import_id" = customs.customs_agency_import.id if customs.customs_agency_import else "",
		"documents" = Document.array_to_dict(documentation.documents),
		"events" = Event.array_to_dict(events.events),
		"quotation_id" = accounting.quotation.id if accounting.quotation else "",
		"charges" = Charge.array_to_dict(accounting.charges),
	}


static func from_dict(data: Dictionary) -> Shipment:
	return Shipment.new().with_data(
		data["id"] as int,
		data["status"] as Shipment.Status,
		data["customer_reference"] as String,
		GlobalRefs.people[data["export_contact_person_id"] as int] if data["export_contact_person_id"] else null,
		GlobalRefs.people[data["import_contact_person_id"] as int] if data["import_contact_person_id"] else null,
		GlobalRefs.parties[data["shipper_id"] as int] as Customer if data["shipper_id"] else null,
		GlobalRefs.parties[data["consignee_id"] as int] as Customer if data["consignee_id"] else null,
		GlobalRefs.locations[data["origin_id"] as int] if data["origin_id"] else null,
		GlobalRefs.locations[data["destination_id"] as int] if data["destination_id"] else null,
		Service.new().with_data(data["service_code"] as Service.Code) if data["service_code"] else null,
		Incoterms.new().with_data(data["incoterms_code"] as Incoterms.Code, data["incoterms_place"] as String) if data["incoterms_code"] else null,
		data["number"] as int,
		GlobalRefs.parties[data["owner_id"] as int] as FreightForwarder if data["owner_id"] else null,
		GlobalRefs.cargos[data["cargo_id"] as int] if data["cargo_id"] else null,
		DimensionSet.array_from_dict(data["dimension_sets"] as Array) if data["dimension_sets"] else [],
		ModeOfTransport.new().with_data(data["mode_of_transport_code"] as ModeOfTransport.Code),
		GlobalRefs.parties[data["carrier_id"] as int] as Carrier if data["carrier_id"] else null,
		GlobalRefs.parties[data["trucker_pickup_id"] as int] as Trucker if data["trucker_pickup_id"] else null,
		GlobalRefs.parties[data["trucker_delivery_id"] as int] as Trucker if data["trucker_delivery_id"] else null,
		GlobalRefs.parties[data["handling_agent_export_id"] as int] as HandlingAgent if data["handling_agent_export_id"] else null,
		GlobalRefs.parties[data["handling_agent_import_id"] as int] as HandlingAgent if data["handling_agent_import_id"] else null,
		GlobalRefs.parties[data["customs_agency_export_id"] as int] as CustomsAgency if data["customs_agency_export_id"] else null,
		GlobalRefs.parties[data["customs_agency_import_id"] as int] as CustomsAgency if data["customs_agency_import_id"] else null,
		Document.array_from_dict(data["documents"] as Array) if data["documents"] else [], ##FIXME - crashes here
		Event.array_from_dict(data["events"] as Array) if data["events"] else [],
		GlobalRefs.quotations[data["quotation_id"] as int] if data["quotation_id"] else null,
		Charge.array_from_dict(data["charges"] as Array) if data["charges"] else [],
	)


static func array_to_dict(data: Array[Shipment]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Shipment in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array[Dictionary]) -> Array[Shipment]:
	var array: Array[Shipment]
	for item: Dictionary in data:
		array.append(Shipment.from_dict(item))
	return array


static func array_to_dict_id(data: Array[Shipment]) -> Array[int]:
	var array: Array[int]
	for item: Shipment in data:
		array.append(item.id)
	return array


static func array_from_dict_id(data: Array[int]) -> Array[Shipment]:
	var array: Array[Shipment]
	for item: int in data:
		array.append(GlobalRefs.shipments[item])
	return array
