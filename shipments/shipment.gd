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
	REJECTED,
}


static var all: Array[Shipment]
static var all_not_owned: Array[Shipment]:
	get:
		return all.filter(func(shipment: Shipment) -> bool: return not shipment.is_owned)

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
var number: int
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


func with_data(shipper_to_assign: Customer = null, consignee_to_assign: Customer = null) -> Shipment:
	last_id += 1
	self.shipment_id = last_id
	
	self.cargo_details = ShipmentCargoDetails.new().with_data(self)
	self.main_freight = ShipmentMainFreight.new().with_data(self)
	self.haulage = ShipmentHaulage.new().with_data(self)
	self.handling = ShipmentHandling.new().with_data(self)
	self.customs = ShipmentCustoms.new().with_data(self)
	self.documentation = ShipmentDocumentation.new().with_data(self)
	self.events = ShipmentEvents.new().with_data(self)
	self.accounting = ShipmentAccounting.new().with_data(self)
	
	self.customer_reference = generate_random_customer_reference(randi_range(3, 5), randi_range(3, 5))
	
	if shipper_to_assign == null:
		shipper_to_assign = Customer.all_specific_with_employees.pick_random()
	self.shipper = shipper_to_assign
	if consignee_to_assign == null:
		consignee_to_assign = Customer.all_specific_with_employees.pick_random()
	self.consignee = consignee_to_assign
	self.export_contact_person = self.shipper.employees.pick_random()
	self.import_contact_person = self.consignee.employees.pick_random()
	
	#FIXME sometimes can be empty, because there are no locations in the customer country
	var origin_list: Array[Location] = Location.all.filter(Location.is_in_country.bind(self.shipper.country))
	var destination_list: Array[Location] = Location.all.filter(Location.is_in_country.bind(self.consignee.country))
	if origin_list.is_empty() or destination_list.is_empty():
		return null
	self.origin = origin_list.pick_random()
	self.destination = destination_list.pick_random()
	
	self.events.create_new_planned_event(Event.Code.ERL, GlobalTimer.get_future_date_from_now(randi_range(1, 20), 10, 0))
	self.events.create_new_planned_event(Event.Code.LTS, GlobalTimer.get_future_date_from_event(self.events.get_first_event_of_type(Event.Code.ERL), randi_range(2, 30), 17, 0))
	
	self.service = Service.new().with_data_random()
	self.incoterms = Incoterms.new().with_data_random()
	var incoterms_location: String
	match self.incoterms.group:
		"C", "D":
			incoterms_location = self.consignee.city_name
		"E", "F":
			incoterms_location = self.shipper.city_name
	self.incoterms.place = incoterms_location
	
	all.append(self)
	print("New shipment created. Shipment ID: %s. There are %s active shipments." % [self.shipment_id, all.size()])
	return self


func remove() -> void:
	all.erase(self)


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
	number = owner.get_next_shipment_number()
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
	if a.number < b.number:
		return true
	return false


static func _sort_ascending_by_earliest_pickup_date(a: Shipment, b: Shipment) -> bool:
	if a.events.get_first_event_of_type(Event.Code.ERL).time < b.events.get_first_event_of_type(Event.Code.ERL).time:
		return true
	return false
