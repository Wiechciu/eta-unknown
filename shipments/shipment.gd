class_name Shipment
extends Resource


signal status_changed(Shipment, Status)
signal completed(Shipment)


enum Status{
	REQUESTED,
	ACCEPTED,
	IN_TRANSIT,
	COMPLETED,
	CANCELLED,
}

static var shipments: Array[Shipment]


var shipment_id: int
@export var customer_reference: String
@export var shipper: Party
@export var consignee: Party
@export var origin: Location
@export var destination: Location
@export var earliest_pickup_date_string: String = "YYYY-MM-DDTHH:MM:SS"
@export var latest_delivery_date_string: String = "YYYY-MM-DDTHH:MM:SS"
@export var dimension_sets: Array[DimensionSet]
var total_quantity:
	get:
		if dimension_sets.size() > 0:
			var quantity: float
			for dimension_set in dimension_sets:
				quantity += dimension_set.quantity
			return quantity
		else:
			return 0
var total_weight:
	get:
		if dimension_sets.size() > 0:
			var weight: float
			for dimension_set in dimension_sets:
				weight += dimension_set.total_weight
			return weight
		else:
			return 0
var total_volume:
	get:
		if dimension_sets.size() > 0:
			var volume: float
			for dimension_set in dimension_sets:
				volume += dimension_set.total_volume
			return volume
		else:
			return 0
@export var status: Status
var is_completed: bool:
	get:
		return status == Status.COMPLETED 

# Accepted shipment variables
var shipment_number: int
var owner: Company


func _init() -> void:
	shipments.append(self)
	shipment_id = shipments.size()


func accept(new_owner: Company) -> void:
	owner = new_owner
	new_owner.add_shipment(self)
	change_status(Status.ACCEPTED)


func change_status(new_status: Status) -> void:
	status = new_status
	status_changed.emit(self, status)
	if status == Status.COMPLETED:
		completed.emit(self)


static func is_shipment_completed(shipment_to_check: Shipment) -> bool:
	return shipment_to_check.is_completed


static func is_shipment_not_completed(shipment_to_check: Shipment) -> bool:
	return not shipment_to_check.is_completed
