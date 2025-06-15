class_name TmsDimensionSet
extends Node


var dimension_set: DimensionSet
@export var quantity_label: Label
@export var length_label: Label
@export var width_label: Label
@export var height_label: Label
@export var total_weight_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func initialize(dimension_set: DimensionSet) -> TmsDimensionSet:
	self.dimension_set = dimension_set
	self.quantity_label.text = "%d pcs" % [dimension_set.quantity]
	self.length_label.text = "%d" % [dimension_set.length]
	self.width_label.text = "%d" % [dimension_set.width]
	self.height_label.text = "%d cm, " % [dimension_set.height]
	self.total_weight_label.text = "%d kg" % [dimension_set.total_weight]

	return self
