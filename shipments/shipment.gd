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
static var last_id: int = 0

var shipment_id: int

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

# Documentation
var commercial_documents: Array[Document] #TODO
var transport_documents: Array[Document] #TODO
var customs_documents: Array[Document] #TODO
var accounting_documents: Array[Document] #TODO

# Cargo details
var cargo: Cargo
var slac: int
var dimension_sets: Array[DimensionSet]
var total_quantity: int:
	get:
		var total: int = 0
		for dimension_set in dimension_sets:
			total += dimension_set.quantity
		return total
var total_weight: float:
	get:
		var total: float = 0
		for dimension_set in dimension_sets:
			total += dimension_set.total_weight
		return total
var total_volume: float:
	get:
		var total: float = 0
		for dimension_set in dimension_sets:
			total += dimension_set.total_volume
		return total
var total_value: float:
	get:
		return slac * cargo.unit_value
var status: Status
var is_completed: bool:
	get:
		return status == Status.COMPLETED 

# Quoted
var quotation: Quotation #TODO

# Accepted shipment variables
var shipment_number: int
var owner: FreightForwarder

# Planned shipment variables
var mode_of_transport: ModeOfTransport #TODO
var planned_pickup_date: int #TODO
var planned_delivery_date: int #TODO
var planned_departure_date: int #TODO
var planned_arrival_date: int #TODO
var trucker_pickup: Trucker #TODO
var trucker_delivery: Trucker #TODO
var carrier: Carrier #TODO
var handling_agent_export: HandlingAgent #TODO
var handling_agent_import: HandlingAgent #TODO
var customs_agency_export: CustomsAgency #TODO
var customs_agency_import: CustomsAgency #TODO
var costs: String #TODO

# In transit
var events: Array[Event] #TODO
var earliest_pickup_date_time_event: TimeEvent
var latest_delivery_date_time_event: TimeEvent
var planned_pickup_date_time_event: TimeEvent
var planned_delivery_date_time_event: TimeEvent
var planned_departure_date_time_event: TimeEvent
var planned_arrival_date_time_event: TimeEvent


static func create_new() -> Shipment:
	var new_shipment = Shipment.new()
	all.append(new_shipment)
	last_id += 1
	new_shipment.shipment_id = last_id
	
	new_shipment.customer_reference = generate_random_customer_reference(randi_range(3, 5), randi_range(3, 5))
	
	new_shipment.shipper = Customer.all_with_employees.pick_random()
	new_shipment.consignee = Customer.all_with_employees.pick_random()
	new_shipment.export_contact_person = new_shipment.shipper.employees.pick_random()
	new_shipment.import_contact_person = new_shipment.consignee.employees.pick_random()
	
	Location.country_to_check = new_shipment.shipper.country
	new_shipment.origin = Location.all.filter(Location.is_in_country).pick_random()
	Location.country_to_check = new_shipment.consignee.country
	new_shipment.destination = Location.all.filter(Location.is_in_country).pick_random()
	
	new_shipment.earliest_pickup_date = GlobalTimer.get_future_date(GlobalTimer.now, randi_range(1, 20), 10, 0)
	new_shipment.latest_delivery_date = GlobalTimer.get_future_date(new_shipment.earliest_pickup_date, randi_range(2, 30), 17, 0)
	
	new_shipment.service = Service.all.pick_random()
	new_shipment.incoterms = Incoterms.all.pick_random()
	var incoterms_place: String
	match new_shipment.incoterms.group:
		"C", "D":
			incoterms_place = new_shipment.consignee.city_name
		"E", "F":
			incoterms_place = new_shipment.shipper.city_name
	new_shipment.incoterms_place = incoterms_place
	
	new_shipment.cargo = Cargo.all.pick_random()
	if new_shipment.cargo.unit_size < 0:
		new_shipment.slac = randi_range(100, 10000)
	elif new_shipment.cargo.unit_size < 5:
		new_shipment.slac = randi_range(10, 1000)
	else:
		new_shipment.slac = randi_range(1, 50)
	
	var dimension_set_count = randi_range(1, 5)
	for n in dimension_set_count:
		var new_dimension_set = DimensionSet.new()
		new_dimension_set.quantity = randi_range(1, 5)
		new_dimension_set.length = randi_range(120, 150)
		new_dimension_set.width = randi_range(80, 120)
		new_dimension_set.height = randi_range(50, 150)
		new_dimension_set.total_weight = randi_range(50, 250)
		new_dimension_set.is_stackable = randi_range(1, 100) > 50
		new_dimension_set.is_dg = randi_range(1, 100) > 90
		new_shipment.dimension_sets.append(new_dimension_set)
	
	new_shipment.earliest_pickup_date_time_event = GlobalTimer.create_time_event(new_shipment.earliest_pickup_date, new_shipment)
	new_shipment.latest_delivery_date_time_event = GlobalTimer.create_time_event(new_shipment.latest_delivery_date, new_shipment)
	
	return new_shipment


static func is_shipment_completed(shipment_to_check: Shipment) -> bool:
	return shipment_to_check.is_completed


static func is_shipment_not_completed(shipment_to_check: Shipment) -> bool:
	return not shipment_to_check.is_completed


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


func accept(new_owner: FreightForwarder) -> void:
	change_status(Status.ACCEPTED)
	owner = new_owner
	shipment_number = owner.get_next_shipment_number()
	new_owner.add_shipment(self)


func change_status(new_status: Status) -> void:
	status = new_status
	status_changed.emit(self)
	if status == Status.COMPLETED:
		completed.emit(self)


func notify(time_event: TimeEvent) -> void:
	match time_event:
		earliest_pickup_date_time_event:
			print_debug("Shipment ID %s earliest_pickup_date_time_event (%s)" % [shipment_id, time_event.time])
		latest_delivery_date_time_event:
			print_debug("Shipment ID %s latest_delivery_date_time_event (%s)" % [shipment_id, time_event.time])
		planned_pickup_date_time_event:
			print_debug("Shipment ID %s planned_pickup_date_time_event (%s)" % [shipment_id, time_event.time])
		planned_delivery_date_time_event:
			print_debug("Shipment ID %s planned_delivery_date_time_event (%s)" % [shipment_id, time_event.time])
		planned_departure_date_time_event:
			print_debug("Shipment ID %s planned_departure_date_time_event (%s)" % [shipment_id, time_event.time])
		planned_arrival_date_time_event:
			print_debug("Shipment ID %s planned_arrival_date_time_event (%s)" % [shipment_id, time_event.time])
	
