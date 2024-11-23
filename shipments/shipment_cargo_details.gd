class_name ShipmentCargoDetails
extends Resource


var shipment: Shipment
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


static func create_new(parent_shipment: Shipment) -> ShipmentCargoDetails:
	var new_cargo_details := ShipmentCargoDetails.new()
	new_cargo_details.shipment = parent_shipment
	
	new_cargo_details.cargo = Cargo.all.pick_random()
	if new_cargo_details.cargo.unit_size < 0:
		new_cargo_details.slac = randi_range(100, 10000)
	elif new_cargo_details.cargo.unit_size < 5:
		new_cargo_details.slac = randi_range(10, 1000)
	else:
		new_cargo_details.slac = randi_range(1, 50)
	
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
		new_cargo_details.dimension_sets.append(new_dimension_set)

	return new_cargo_details
