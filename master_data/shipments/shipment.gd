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


var id: int
var status: Status
var status_string: String:
	get: return "SHIPMENT_STATUS_" + Status.keys()[status]
var is_completed_or_cancelled: bool:
	get:
		return status == Status.COMPLETED or status == Status.CANCELLED

# General
var customer_reference: String
var export_contact_person: Person
var import_contact_person: Person
var shipper: Party
var consignee: Party
var origin: Location
var destination: Location
var service: Service
var incoterms: Incoterms

# Accepted shipment variables
var number: int
var owner: Party
var is_owned: bool:
	get:
		return owner != null

# Shipment modules
var cargo_details: ShipmentCargoDetails
var main_freight: ShipmentMainFreight
var haulage: ShipmentHaulage
var handling: ShipmentHandling
var customs: ShipmentCustoms
var documentation: ShipmentDocumentation
var events: ShipmentEvents
var accounting: ShipmentAccounting


@warning_ignore("shadowed_variable")
static func create_new(id: int, status: Status, customer_reference: String, export_contact_person: Person, import_contact_person: Person, shipper: Party, consignee: Party, origin: Location, destination: Location, service: Service, incoterms: Incoterms, number: int, owner: Party, cargo: Cargo, dimension_sets: Array[DimensionSet], mode_of_transport: ModeOfTransport, carrier: Party, trucker_pickup: Party, trucker_delivery: Party, handling_agent_export: Party, handling_agent_import: Party, customs_agency_export: Party, customs_agency_import: Party, documents: Array[Document], events: Array[Event], quotation: Quotation, charges: Array[Charge]) -> Shipment:
	var new_shipment: Shipment = Shipment.new()
	new_shipment.id = id
	new_shipment.status = status
	new_shipment.customer_reference = customer_reference
	new_shipment.export_contact_person = export_contact_person
	new_shipment.import_contact_person = import_contact_person
	new_shipment.shipper = shipper
	new_shipment.consignee = consignee
	new_shipment.origin = origin
	new_shipment.destination = destination
	new_shipment.service = service
	new_shipment.incoterms = incoterms
	
	new_shipment.number = number
	new_shipment.owner = owner
	
	new_shipment.cargo_details = ShipmentCargoDetails.create_new(cargo, dimension_sets)
	new_shipment.main_freight = ShipmentMainFreight.create_new(mode_of_transport, carrier)
	new_shipment.haulage = ShipmentHaulage.create_new(trucker_pickup, trucker_delivery)
	new_shipment.handling = ShipmentHandling.create_new(handling_agent_export, handling_agent_import)
	new_shipment.customs = ShipmentCustoms.create_new(customs_agency_export, customs_agency_import)
	new_shipment.documentation = ShipmentDocumentation.create_new(documents)
	new_shipment.events = ShipmentEvents.create_new(new_shipment, events)
	new_shipment.accounting = ShipmentAccounting.create_new(quotation, charges)
	
	GlobalRefs.shipments.append(new_shipment)
	GlobalRefs.shipments_dict[id] = new_shipment

	return new_shipment


@warning_ignore_start("shadowed_variable")
static func create_new_with_random_data(shipper_to_assign: Party = null, consignee_to_assign: Party = null) -> Shipment:
	var id: int = GlobalRefs.get_shipment_id()
	
	#var cargo_details: ShipmentCargoDetails = ShipmentCargoDetails.create_new_with_random_data()
	#var main_freight: ShipmentMainFreight = ShipmentMainFreight.new()
	#var haulage: ShipmentHaulage = ShipmentHaulage.new()
	#var handling: ShipmentHandling = ShipmentHandling.new()
	#var customs: ShipmentCustoms = ShipmentCustoms.new()
	#var documentation: ShipmentDocumentation = ShipmentDocumentation.new()
	#var events: ShipmentEvents = ShipmentEvents.new()
	#var accounting: ShipmentAccounting = ShipmentAccounting.new()
	
	var events: Array[Event]
	events.append(Event.create_new("ERL", Event.Type.PLANNED, GlobalTimer.get_future_date_from_now(randi_range(1, 20), 10, 0)))
	events.append(Event.create_new("LTS", Event.Type.PLANNED, GlobalTimer.get_future_date_from_event(events[0], randi_range(2, 30), 17, 0)))

	var customer_reference: String = generate_random_customer_reference(randi_range(3, 5), randi_range(3, 5))
	
	if shipper_to_assign == null:
		shipper_to_assign = GlobalRefs.customers_with_employees.pick_random()
	var shipper: Party = shipper_to_assign
	if consignee_to_assign == null:
		consignee_to_assign = GlobalRefs.customers_with_employees.pick_random()
	var consignee: Party = consignee_to_assign
	#FIXME make it always be in a different country.
	if shipper.country == consignee.country:
		return null
	
	var export_contact_person: Person = shipper.employees.pick_random()
	var import_contact_person: Person = consignee.employees.pick_random()
	
	var origin_list: Array[Location] = shipper.country.locations
	var destination_list: Array[Location] = consignee.country.locations
	#FIXME sometimes origin or destination can be empty, because there are no locations in the customer country.
	if origin_list.is_empty() or destination_list.is_empty():
		return null

	var origin: Location = origin_list.pick_random() as Location
	var destination: Location = destination_list.pick_random() as Location
	
	var service: Service = Service.create_new_with_random_data()
	var incoterms: Incoterms = Incoterms.create_new_with_random_data()
	var incoterms_location: String
	match incoterms.incoterms_data.group:
		"C", "D":
			incoterms_location = consignee.city_name
		"E", "F":
			incoterms_location = shipper.city_name
	incoterms.place = incoterms_location
	
	var random_cargo: Cargo = GlobalRefs.cargos.pick_random()
	var random_dimension_sets: Array[DimensionSet]
	
	var dimension_set_count: int = randi_range(1, 5)
	for n: int in dimension_set_count:
		var new_dimension_set: DimensionSet = DimensionSet.create_new_with_random_data()
		random_dimension_sets.append(new_dimension_set)
	
	return create_new(
		id,
		Status.REQUESTED,
		customer_reference,
		export_contact_person,
		import_contact_person,
		shipper,
		consignee,
		origin,
		destination,
		service,
		incoterms,
		0,
		null,
		random_cargo,
		random_dimension_sets,
		GlobalRefs.modes_of_transport.pick_random(),
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		[],
		events,
		null,
		[]
	)
@warning_ignore_restore("shadowed_variable")


func remove() -> void:
	GlobalRefs.shipments.erase(self)


static func generate_random_customer_reference(string_length: int, number_length: int) -> String:
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


func accept(new_owner: Party) -> void:
	events.register_new_actual_event_now("BOK")
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


#func to_dict() -> Dictionary:
	#var dimension_sets: Array[Dictionary]
	#for dimension_set: DimensionSet in cargo_details.dimension_sets:
		#dimension_sets.append(dimension_set.to_dict())
	#
	#return {
		#"id" = id,
		#"status" = status,
		#"customer_reference" = customer_reference,
		#"export_contact_person_id" = str(export_contact_person.id) if export_contact_person else "",
		#"import_contact_person_id" = str(import_contact_person.id) if import_contact_person else "",
		#"shipper_id" = str(shipper.id) if shipper else "",
		#"consignee_id" = str(consignee.id) if consignee else "",
		#"origin_id" = str(origin.id) if origin else "",
		#"destination_id" = str(destination.id) if destination else "",
		#"service_code" = str(service.code) if service else "",
		#"incoterms_code" = str(incoterms.code) if incoterms else "",
		#"incoterms_place" = incoterms.place if incoterms else "",
		#"number" = number,
		#"owner_id" = str(owner.id) if owner else "",
		#"cargo_id" = str(cargo_details.cargo.id) if cargo_details.cargo else "",
		#"dimension_sets" = DimensionSet.array_to_dict(cargo_details.dimension_sets),
		#"mode_of_transport_code" = str(main_freight.mode_of_transport.code) if main_freight.mode_of_transport else "",
		#"carrier_id" = str(main_freight.carrier.id) if main_freight.carrier else "",
		#"trucker_pickup_id" = str(haulage.trucker_pickup.id) if haulage.trucker_pickup else "",
		#"trucker_delivery_id" = str(haulage.trucker_delivery.id) if haulage.trucker_delivery else "",
		#"handling_agent_export_id" = str(handling.handling_agent_export.id) if handling.handling_agent_export else "",
		#"handling_agent_import_id" = str(handling.handling_agent_import.id) if handling.handling_agent_import else "",
		#"customs_agency_export_id" = str(customs.customs_agency_export.id) if customs.customs_agency_export else "",
		#"customs_agency_import_id" = str(customs.customs_agency_import.id) if customs.customs_agency_import else "",
		##"documents" = Document.array_to_dict(documentation.documents),
		#"events" = Event.array_to_dict(events.events),
		#"quotation_id" = str(accounting.quotation.id) if accounting.quotation else "",
		#"charges" = Charge.array_to_dict(accounting.charges),
	#}
#
#
#static func from_dict(data: Dictionary) -> Shipment:
	#return Shipment.new().with_data(
		#data.id as int,
		#data.status as Shipment.Status,
		#data.customer_reference as String,
		#null,
		#null,
		#null,
		#null,
		#null,
		#null,
		#Service.new().with_data(data.service_code as Service.Code) if data.service_code else null,
		#Incoterms.new().with_data(data.incoterms_code as Incoterms.Code, data.incoterms_place as String) if data.incoterms_code else null,
		#data.number as int,
		#null,
		#GlobalRefs.cargos[data.cargo_id as int] if data.cargo_id else null,
		#DimensionSet.array_from_dict(data.dimension_sets as Array[Dictionary]) if data.dimension_sets else ([] as Array[DimensionSet]),
		#ModeOfTransport.new().with_data(data.mode_of_transport_code as ModeOfTransport.Code),
		#null,
		#null,
		#null,
		#null,
		#null,
		#null,
		#null,
		#Document.array_from_dict(data.documents as Array[Dictionary]) if data.documents else ([] as Array[Document]),
		#Event.array_from_dict(data.events as Array[Dictionary]) if data.events else ([] as Array[Event]),
		#null,
		#Charge.array_from_dict(data.charges as Array[Dictionary]) if data.charges else ([] as Array[Charge]),
	#)
#
#
#func assign_references_from_dict(data: Dictionary) -> void:
	#self.export_contact_person = GlobalRefs.people_dict[data.export_contact_person_id as int] if data.export_contact_person_id else null
	#self.import_contact_person = GlobalRefs.people_dict[data.import_contact_person_id as int] if data.import_contact_person_id else null
	#self.shipper = GlobalRefs.parties_dict[data.shipper_id as int] if data.shipper_id else null
	#self.consignee = GlobalRefs.parties_dict[data.consignee_id as int] if data.consignee_id else null
	#self.origin = GlobalRefs.locations[data.origin_id as int] if data.origin_id else null
	#self.destination = GlobalRefs.locations[data.destination_id as int] if data.destination_id else null
	#self.owner = GlobalRefs.parties_dict[data.owner_id as int] if data.owner_id else null
	#self.main_freight.carrier = GlobalRefs.parties_dict[data.carrier_id as int] if data.carrier_id else null
	#self.haulage.trucker_pickup = GlobalRefs.parties_dict[data.trucker_pickup_id as int] if data.trucker_pickup_id else null
	#self.haulage.trucker_delivery = GlobalRefs.parties_dict[data.trucker_delivery_id as int] if data.trucker_delivery_id else null
	#self.handling.handling_agent_export = GlobalRefs.parties_dict[data.handling_agent_export_id as int] if data.handling_agent_export_id else null
	#self.handling.handling_agent_import = GlobalRefs.parties_dict[data.handling_agent_import_id as int] if data.handling_agent_import_id else null
	#self.customs.customs_agency_export = GlobalRefs.parties_dict[data.customs_agency_export_id as int] if data.customs_agency_export_id else null
	#self.customs.customs_agency_import = GlobalRefs.parties_dict[data.customs_agency_import_id as int] if data.customs_agency_import_id else null
	#self.accounting.quotation = GlobalRefs.quotations_dict[data.quotation_id as int] if data.quotation_id else null
#
#
#static func array_to_dict(data: Array[Shipment]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Shipment in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Shipment]:
	#var array: Array[Shipment]
	#for item: Dictionary in data:
		#array.append(Shipment.from_dict(item))
	#return array
#
#
#static func array_to_dict_id(data: Array[Shipment]) -> Array[int]:
	#var array: Array[int]
	#for item: Shipment in data:
		#array.append(item.id)
	#return array
#
#
#static func array_from_dict_id(data: Array) -> Array[Shipment]:
	#var array: Array[Shipment]
	#for item: int in data:
		#array.append(GlobalRefs.shipments_dict[item])
	#return array
