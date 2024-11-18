class_name TmsDimensionSet
extends Node


@export_category("Assigned internally")
@export var quantity: Label
@export var length: Label
@export var width: Label
@export var height: Label
@export var total_weight: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func with_data(dimension_set: DimensionSet) -> TmsDimensionSet:
	quantity.text = "%d pcs" % [dimension_set.quantity]
	length.text = "%d" % [dimension_set.length]
	width.text = "%d" % [dimension_set.width]
	height.text = "%d cm, " % [dimension_set.height]
	total_weight.text = "%d kg" % [dimension_set.total_weight]

	return self
