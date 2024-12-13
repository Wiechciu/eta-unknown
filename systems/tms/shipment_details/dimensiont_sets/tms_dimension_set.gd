class_name TmsDimensionSet
extends Node


var dimension_set: DimensionSet
@export var quantity_label: Label
@export var length_label: Label
@export var width_label: Label
@export var height_label: Label
@export var total_weight_label: Label


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(dimension_set: DimensionSet) -> TmsDimensionSet:
	self.dimension_set = dimension_set
	quantity_label.text = "%d pcs" % [dimension_set.quantity]
	length_label.text = "%d" % [dimension_set.length]
	width_label.text = "%d" % [dimension_set.width]
	height_label.text = "%d cm, " % [dimension_set.height]
	total_weight_label.text = "%d kg" % [dimension_set.total_weight]

	return self
