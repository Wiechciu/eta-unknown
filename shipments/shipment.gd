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
	@warning_ignore("unsafe_property_access")
	id = GlobalRefs.shipment_last_id
	
	cargo_details = ShipmentCargoDetails.new().with_data(self)
	main_freight = ShipmentMainFreight.new().with_data(self)
	haulage = ShipmentHaulage.new().with_data(self)
	handling = ShipmentHandling.new().with_data(self)
	customs = ShipmentCustoms.new().with_data(self)
	documentation = ShipmentDocumentation.new().with_data(self)
	events = ShipmentEvents.new().with_data(self)
	accounting = ShipmentAccounting.new().with_data(self)
	
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
