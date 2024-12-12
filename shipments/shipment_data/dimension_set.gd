class_name DimensionSet
extends Resource


@export_storage var quantity: int
@export_storage var length: float
@export_storage var width: float
@export_storage var height: float
@export_storage var total_weight: float
@export_storage var is_stackable: bool
@export_storage var is_dg: bool
var total_volume: float:
	get:
		return snappedf(quantity * length * width * height / 1000000, 0.001)


@warning_ignore("shadowed_variable")
func with_data(quantity: int, length: float, width: float, height: float, total_weight: float, is_stackable: bool, is_dg: bool) -> DimensionSet:
	self.quantity = quantity
	self.length = length
	self.width = width
	self.height = height
	self.total_weight = total_weight
	self.is_stackable = is_stackable
	self.is_dg = is_dg
	
	return self


func with_data_random() -> DimensionSet:
	return with_data(
		randi_range(1, 5),
		randi_range(120, 150),
		randi_range(80, 120),
		randi_range(50, 150),
		randi_range(50, 250),
		randi_range(1, 100) > 50,
		randi_range(1, 100) > 90
		)
