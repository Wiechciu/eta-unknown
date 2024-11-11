class_name DimensionSet
extends Resource


@export var quantity: int
@export var length: float
@export var width: float
@export var height: float
@export var total_weight: float
@export var is_stackable: bool
@export var is_dg: bool
var total_volume:
	get:
		return quantity * length * width * height / 1000000
