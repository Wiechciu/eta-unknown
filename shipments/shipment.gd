class_name Shipment
extends Resource


signal status_changed(Shipment)
signal completed(Shipment)


enum ModeOfTransport {
	NONE,
	AIR,
	SEA,
	LAND,
	RAIL,
}

enum Status {
	REQUESTED,
	QUOTED,
	ACCEPTED,
	PLANNED,
	IN_TRANSIT,
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
var earliest_pickup_date: int
var latest_delivery_date: int
var service: Service
var incoterms: Incoterms
var incoterms_place: String
var incoterms_full: String:
	get:
		return (incoterms.code + " " + incoterms_place) if incoterms else ""

# Shipment modules
var cargo_details: ShipmentCargoDetails
var main_freight: ShipmentMainFreight
var haulage: ShipmentHaulage
var handling: ShipmentHandling
var customs: ShipmentCustoms
var documentation: ShipmentDocumentation
var events: ShipmentEvents
var accounting: ShipmentAccounting

# Accepted shipment variables
var shipment_number: int
var owner: FreightForwarder
var is_owned: bool:
	get:
		return owner != null



static func create_new(shipper: Customer = null, consignee: Customer = null) -> Shipment:
	var new_shipment = Shipment.new()
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
	
	new_shipment.origin = Location.all.filter(Location.is_in_country.bind(new_shipment.shipper.country)).pick_random()
	new_shipment.destination = Location.all.filter(Location.is_in_country.bind(new_shipment.consignee.country)).pick_random()
	
	#FIXME sometimes can be empty, because there are no locations in the customer country
	if new_shipment.origin == null or new_shipment.destination == null:
		return null
	
	new_shipment.earliest_pickup_date = GlobalTimer.get_future_date(GlobalTimer.now, randi_range(1, 20), 10, 0)
	new_shipment.latest_delivery_date = GlobalTimer.get_future_date(new_shipment.earliest_pickup_date, randi_range(2, 30), 17, 0)
	new_shipment.events.create_time_events()
	
	new_shipment.service = Service.all.pick_random()
	new_shipment.incoterms = Incoterms.all.pick_random()
	var incoterms_place: String
	match new_shipment.incoterms.group:
		"C", "D":
			incoterms_place = new_shipment.consignee.city_name
		"E", "F":
			incoterms_place = new_shipment.shipper.city_name
	new_shipment.incoterms_place = incoterms_place
	
	
	print("New shipment created. Shipment ID: " + str(new_shipment.shipment_id))
	return new_shipment


static func generate_random_customer_reference(string_length: int, number_length: int) -> String:
	var word: String
	var allowed_characters_in_string := "abcdefghijklmnopqrstvwxyz"
	var allowed_characters_in_number := "1234567890"
	
	var n_char := len(allowed_characters_in_string)
	for i in range(string_length):
		word += allowed_characters_in_string[randi()% n_char].to_upper()
	
	n_char = len(allowed_characters_in_number)
	for i in range(number_length):
		word += allowed_characters_in_number[randi()% n_char]
	
	return word


static func sort_shipment_list_by_shipment_number(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_shipment_number)
	return shipment_list


static func sort_shipment_list_by_earliest_pickup_date(shipment_list: Array[Shipment]) -> Array[Shipment]:
	shipment_list.sort_custom(_sort_ascending_by_earliest_pickup_date)
	return shipment_list


func accept(new_owner: FreightForwarder) -> void:
	change_status(Status.ACCEPTED)
	owner = new_owner
	shipment_number = owner.get_next_shipment_number()
	new_owner.accept_shipment(self)


func change_status(new_status: Status) -> void:
	status = new_status
	status_changed.emit(self)
	if status == Status.COMPLETED:
		completed.emit(self)


static func _sort_ascending_by_shipment_number(a: Shipment, b: Shipment) -> bool:
	if a.shipment_number < b.shipment_number:
		return true
	return false


static func _sort_ascending_by_earliest_pickup_date(a: Shipment, b: Shipment) -> bool:
	if a.earliest_pickup_date < b.earliest_pickup_date:
		return true
	return false
