class_name DimensionSet
extends Resource


var quantity: int
var length: float
var width: float
var height: float
var total_weight: float
var is_stackable: bool
var is_dg: bool
var total_volume: float:
	get:
		return snappedf(quantity * length * width * height / 1000000, 0.001)


@warning_ignore("shadowed_variable")
static func create_new(quantity: int, length: float, width: float, height: float, total_weight: float, is_stackable: bool, is_dg: bool) -> DimensionSet:
	var new_dimension_set: DimensionSet = DimensionSet.new()
	new_dimension_set.quantity = quantity
	new_dimension_set.length = length
	new_dimension_set.width = width
	new_dimension_set.height = height
	new_dimension_set.total_weight = total_weight
	new_dimension_set.is_stackable = is_stackable
	new_dimension_set.is_dg = is_dg
	
	return new_dimension_set


static func create_new_with_random_data() -> DimensionSet:
	return create_new(
		randi_range(1, 5),
		randi_range(120, 150),
		randi_range(80, 120),
		randi_range(50, 150),
		randi_range(50, 250),
		randi_range(1, 100) > 50,
		randi_range(1, 100) > 90
	)


#func to_dict() -> Dictionary:
	#return {
		#"quantity" = quantity,
		#"length" = length,
		#"width" = width,
		#"height" = height,
		#"total_weight" = total_weight,
		#"is_stackable" = is_stackable,
		#"is_dg" = is_dg,
	#}
#
#
#static func from_dict(data: Dictionary) -> DimensionSet:
	#return DimensionSet.new().with_data(
		#data["quantity"],
		#data["length"],
		#data["width"],
		#data["height"],
		#data["total_weight"],
		#data["is_stackable"],
		#data["is_dg"],
	#)
#
#
#static func array_to_dict(data: Array[DimensionSet]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: DimensionSet in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[DimensionSet]:
	#var array: Array[DimensionSet]
	#for item: Dictionary in data:
		#array.append(DimensionSet.from_dict(item))
	#return array
