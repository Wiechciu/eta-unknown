class_name Shipment
extends Resource


signal details_changed(Shipment)
signal status_changed(Shipment)
signal completed(Shipment)


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
	REJECTED,
}


static var all: Array[Shipment]
static var all_not_owned: Array[Shipment]:
	get:
		return all.filter(func(shipment: Shipment): return not shipment.is_owned)

static var last_id: int = 0

var shipment_id: int
var status: Status
var is_completed: bool:
	get:
		return status == Status.COMPLETED 

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
var shipment_number: int
var owner: FreightForwarder
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


static func create_new(shipper: Customer = null, consignee: Customer = null) -> Shipment:
	var new_shipment := Shipment.new()
	all.append(new_shipment)
	last_id += 1
	new_shipment.shipment_id = last_id
	
	new_shipment.cargo_details = ShipmentCargoDetails.create_new(new_shipment)
	new_shipment.main_freight = ShipmentMainFreight.create_new(new_shipment)
	new_shipment.haulage = ShipmentHaulage.create_new(new_shipment)
	new_shipment.handling = ShipmentHandling.create_new(new_shipment)
	new_shipment.customs = ShipmentCustoms.create_new(new_shipment)
	new_shipment.documentation = ShipmentDocumentation.create_new(new_shipment)
	new_shipment.events = ShipmentEvents.create_new(new_shipment)
	new_shipment.accounting = ShipmentAccounting.create_new(new_shipment)
	
	new_shipment.customer_reference = generate_random_customer_reference(randi_range(3, 5), randi_range(3, 5))
	
	if shipper == null:
		shipper = Customer.all_specific_with_employees.pick_random()
	new_shipment.shipper = shipper
	if consignee == null:
		consignee = Customer.all_specific_with_employees.pick_random()
	new_shipment.consignee = consignee
	new_shipment.export_contact_person = new_shipment.shipper.employees.pick_random()
	new_shipment.import_contact_person = new_shipment.consignee.employees.pick_random()
	
	#FIXME sometimes can be empty, because there are no locations in the customer country
	var origin_list := Location.all.filter(Location.is_in_country.bind(new_shipment.shipper.country))
	var destination_list := Location.all.filter(Location.is_in_country.bind(new_shipment.consignee.country))
	if origin_list.is_empty() or destination_list.is_empty():
		return null
	new_shipment.origin = origin_list.pick_random()
	new_shipment.destination = destination_list.pick_random()
	
	new_shipment.events.create_new_planned_event(Event.Code.ERL, GlobalTimer.get_future_date_from_now(randi_range(1, 20), 10, 0))
	new_shipment.events.create_new_planned_event(Event.Code.LTS, GlobalTimer.get_future_date_from_event(new_shipment.events.get_first_event_of_type(Event.Code.ERL), randi_range(2, 30), 17, 0))
	
	new_shipment.service = Service.create_new_with_random_code()
	new_shipment.incoterms = Incoterms.create_new_with_random_code()
	var incoterms_location: String
	match new_shipment.incoterms.group:
		"C", "D":
			incoterms_location = new_shipment.consignee.city_name
		"E", "F":
			incoterms_location = new_shipment.shipper.city_name
	new_shipment.incoterms.place = incoterms_location
	
	print("New shipment created. Shipment ID: " + str(new_shipment.shipment_id))
	return new_shipment


static func generate_random_customer_reference(string_length: int, number_length: int) -> String:
	var random_customer_reference: String = ""
	var allowed_characters_in_string := "abcdefghijklmnopqrstvwxyz"
	var allowed_characters_in_number := "1234567890"
	
	var n_char := len(allowed_characters_in_string)
	for i in range(string_length):
		random_customer_reference += allowed_characters_in_string[randi()% n_char].to_upper()
	
	n_char = len(allowed_characters_in_number)
	for i in range(number_length):
		random_customer_reference += allowed_characters_in_number[randi()% n_char]
	
	return random_customer_reference


static func sort_shipment_list_by_shipment_number(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_shipment_number)
	return shipment_list


static func sort_shipment_list_by_earliest_pickup_date(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_earliest_pickup_date)
	return shipment_list


func accept(new_owner: FreightForwarder) -> void:
	events.create_new_actual_event_now(Event.Code.BOK)
	change_status(Status.ACCEPTED)
	owner = new_owner
	shipment_number = owner.get_next_shipment_number()
	new_owner.accept_shipment(self)


func change_status(new_status: Status) -> void:
	if status > new_status:
		return
	
	status = new_status
	if status == Status.COMPLETED:
		completed.emit(self)
	status_changed.emit(self)
	details_changed.emit(self)


func notify_details_changed() -> void:
	details_changed.emit()


static func _sort_ascending_by_shipment_number(a: Shipment, b: Shipment) -> bool:
	if a.shipment_number < b.shipment_number:
		return true
	return false


static func _sort_ascending_by_earliest_pickup_date(a: Shipment, b: Shipment) -> bool:
	if a.events.get_first_event_of_type(Event.Code.ERL).time < b.events.get_first_event_of_type(Event.Code.ERL).time:
		return true
	return false
