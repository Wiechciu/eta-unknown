class_name TmsDimensionSet
extends Node


@export var _quantity: Label
@export var _length: Label
@export var _width: Label
@export var _height: Label
@export var _total_weight: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func with_data(dimension_set: DimensionSet) -> TmsDimensionSet:
	_quantity.text = "%d pcs" % [dimension_set.quantity]
	_length.text = "%d" % [dimension_set.length]
	_width.text = "%d" % [dimension_set.width]
	_height.text = "%d cm, " % [dimension_set.height]
	_total_weight.text = "%d kg" % [dimension_set.total_weight]

	return self
