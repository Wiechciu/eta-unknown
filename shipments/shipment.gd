class_name Shipment
extends Resource


signal status_changed(Shipment, Status)
signal completed(Shipment)


enum Status{
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

static var shipments: Array[Shipment]


var shipment_id: int

var customer_reference: String #TODO
var customer_contact_person: Person #TODO
var shipper: Party
var consignee: Party
var origin: Location
var destination: Location
var earliest_pickup_date_string: String = "YYYY-MM-DDTHH:MM:SS"
var latest_delivery_date_string: String = "YYYY-MM-DDTHH:MM:SS"
var incoterms_code: String #TODO
var incoterms_place: String #TODO
var service: String #TODO
var commercial_documents: String #TODO
var transport_documents: String #TODO
var customs_documents: String #TODO

var dimension_sets: Array[DimensionSet]
var total_quantity:
	get:
		if dimension_sets.size() > 0:
			var quantity: float = 0
			for dimension_set in dimension_sets:
				quantity += dimension_set.quantity
			return quantity
		else:
			return 0
var total_weight:
	get:
		if dimension_sets.size() > 0:
			var weight: float = 0
			for dimension_set in dimension_sets:
				weight += dimension_set.total_weight
			return weight
		else:
			return 0
var total_volume:
	get:
		if dimension_sets.size() > 0:
			var volume: float = 0
			for dimension_set in dimension_sets:
				volume += dimension_set.total_volume
			return volume
		else:
			return 0
var status: Status
var is_completed: bool:
	get:
		return status == Status.COMPLETED 

# Quoted
var quotation: String #TODO

# Accepted shipment variables
var shipment_number: int
var owner: Company

# Planned shipment variables
var planned_pickup_date_string: String = "YYYY-MM-DDTHH:MM:SS" #TODO
var planned_delivery_date_string: String = "YYYY-MM-DDTHH:MM:SS" #TODO
var trucker_pickup: String #TODO
var trucker_delivery: String #TODO
var carrier: String #TODO
var customs_agency: String #TODO
var costs: String #TODO

# In transit
var events: String #TODO


static func new_random_shipment() -> Shipment:
	var new_shipment = Shipment.new()
	
	new_shipment.shipper = Constants.parties.pick_random()
	new_shipment.consignee = Constants.parties.pick_random()
	
	Location.country_code_to_check = new_shipment.shipper.country_code
	new_shipment.origin = Constants.locations.filter(Location.is_in_country).pick_random()
	
	Location.country_code_to_check = new_shipment.consignee.country_code
	new_shipment.destination = Constants.locations.filter(Location.is_in_country).pick_random()
	
	var random_pickup_day = randi_range(2, 5)
	new_shipment.earliest_pickup_date_string = "2025-01-" + str(random_pickup_day) + "T10:00:00"
	
	var random_delivery_day = randi_range(10, 20)
	new_shipment.latest_delivery_date_string = "2025-01-" + str(random_delivery_day) + "T17:00:00"
	
	var dimension_set_count = randi_range(1, 10)
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
	
	return new_shipment


static func is_shipment_completed(shipment_to_check: Shipment) -> bool:
	return shipment_to_check.is_completed


static func is_shipment_not_completed(shipment_to_check: Shipment) -> bool:
	return not shipment_to_check.is_completed


func _init() -> void:
	shipments.append(self)
	shipment_id = shipments.size()


func accept(new_owner: Company) -> void:
	change_status(Status.ACCEPTED)
	owner = new_owner
	shipment_number = owner.get_next_shipment_number()
	new_owner.add_shipment(self)


func change_status(new_status: Status) -> void:
	status = new_status
	status_changed.emit(self, status)
	if status == Status.COMPLETED:
		completed.emit(self)
