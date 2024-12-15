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
func with_data(cargo: Cargo, dimension_sets: Array[DimensionSet]) -> ShipmentCargoDetails:
	self.cargo = cargo
	self.dimension_sets = dimension_sets
	return self


func with_data_random() -> ShipmentCargoDetails:
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	var random_cargo: Cargo = GlobalRefs.cargos.pick_random()
	var random_dimension_sets: Array[DimensionSet]
	
	var dimension_set_count: int = randi_range(1, 5)
	for n: int in dimension_set_count:
		var new_dimension_set: DimensionSet = DimensionSet.new().with_data_random()
		random_dimension_sets.append(new_dimension_set)
	
	return with_data(random_cargo, random_dimension_sets)
