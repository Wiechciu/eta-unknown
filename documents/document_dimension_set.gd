class_name DocumentDimensionSet
extends Node


@export_category("Assigned internally")
@export var quantity: Label
@export var length: Label
@export var width: Label
@export var height: Label
@export var total_weight: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
