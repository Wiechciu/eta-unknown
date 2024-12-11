class_name ShipmentCargoDetails
extends Resource


@export_storage var shipment: Shipment
@export_storage var cargo: Cargo
@export_storage var slac: int
@export_storage var dimension_sets: Array[DimensionSet]
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
		return slac * cargo.unit_value


func with_data(parent_shipment: Shipment) -> ShipmentCargoDetails:
	self.shipment = parent_shipment
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	self.cargo = GlobalRefs.cargos.pick_random()
	if self.cargo.unit_size < 0:
		self.slac = randi_range(100, 10000)
	elif self.cargo.unit_size < 5:
		self.slac = randi_range(10, 1000)
	else:
		self.slac = randi_range(1, 50)
	
	var dimension_set_count: int = randi_range(1, 5)
	for n: int in dimension_set_count:
		var new_dimension_set: DimensionSet = DimensionSet.new()
		new_dimension_set.quantity = randi_range(1, 5)
		new_dimension_set.length = randi_range(120, 150)
		new_dimension_set.width = randi_range(80, 120)
		new_dimension_set.height = randi_range(50, 150)
		new_dimension_set.total_weight = randi_range(50, 250)
		new_dimension_set.is_stackable = randi_range(1, 100) > 50
		new_dimension_set.is_dg = randi_range(1, 100) > 90
		self.dimension_sets.append(new_dimension_set)

	return self
