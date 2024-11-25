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
