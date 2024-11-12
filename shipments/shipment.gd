class_name Shipment
extends Resource


enum Status{
	REQUESTED,
	ACCEPTED,
	IN_TRANSIT,
	COMPLETED,
}


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
