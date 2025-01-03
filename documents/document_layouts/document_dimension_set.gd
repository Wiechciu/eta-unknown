class_name DocumentDimensionSet
extends Node


@export_category("Assigned internally")
@export var quantity: Label
@export var length: Label
@export var width: Label
@export var height: Label
@export var total_weight: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


func with_data(dimension_set: DimensionSet) -> DocumentDimensionSet:
	quantity.text = "%d %s" % [dimension_set.quantity, tr("PCS")]
	length.text = "%d" % [dimension_set.length]
	width.text = "%d" % [dimension_set.width]
	height.text = "%d %s, " % [dimension_set.height, tr("CM")]
	total_weight.text = "%d %s" % [dimension_set.total_weight, tr("KG")]
	return self
