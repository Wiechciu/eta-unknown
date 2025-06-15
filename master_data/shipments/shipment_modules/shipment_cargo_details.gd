class_name ShipmentCargoDetails
extends Resource


var cargo: Cargo
var dimension_sets: Array[DimensionSet]
var total_quantity: int:
	get:
		var total: int = 0
		for dimension_set: DimensionSet in dimension_sets:
			total += dimension_set.quantity
		return total
var total_weight: float:
	get:
		var total: float = 0
		for dimension_set: DimensionSet in dimension_sets:
			total += dimension_set.total_weight
		return total
var total_volume: float:
	get:
		var total: float = 0
		for dimension_set: DimensionSet in dimension_sets:
			total += dimension_set.total_volume
		return total
var total_value: float:
	get:
		return total_quantity * cargo.unit_value


@warning_ignore("shadowed_variable")
static func create_new(cargo: Cargo, dimension_sets: Array[DimensionSet]) -> ShipmentCargoDetails:
	var new_shipment_cargo_details: ShipmentCargoDetails = ShipmentCargoDetails.new()
	new_shipment_cargo_details.cargo = cargo
	new_shipment_cargo_details.dimension_sets = dimension_sets
	return new_shipment_cargo_details


static func create_new_with_random_data() -> ShipmentCargoDetails:
	var random_cargo: Cargo = GlobalRefs.cargos.pick_random()
	var random_dimension_sets: Array[DimensionSet]
	
	var dimension_set_count: int = randi_range(1, 5)
	for n: int in dimension_set_count:
		var new_dimension_set: DimensionSet = DimensionSet.create_new_with_random_data()
		random_dimension_sets.append(new_dimension_set)
	
	return create_new(
		random_cargo,
		random_dimension_sets
	)
