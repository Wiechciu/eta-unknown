class_name TmsShipmentDetailsCargoDetails
extends PanelContainer


var shipment: Shipment

@export var _cargo_description: Label
@export var _slac: Label
@export var _total_quantity: Label
@export var _total_weight: Label
@export var _total_volume: Label
@export var _dimension_sets_container: Control
@export var _tms_dimension_set_scene: PackedScene


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_cargo_description.text = shipment.cargo_details.cargo.description if shipment.cargo_details.cargo else ""
	_slac.text = "%d pcs" % [shipment.cargo_details.slac]
	_total_quantity.text = "%d pcs" % [shipment.cargo_details.total_quantity]
	_total_weight.text = "%d kg" % [shipment.cargo_details.total_weight]
	_total_volume.text = "%.3f cbm" % [shipment.cargo_details.total_volume]

	for child in _dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set in shipment.cargo_details.dimension_sets:
		var tms_dimension_set: TmsDimensionSet = (_tms_dimension_set_scene.instantiate() as TmsDimensionSet).with_data(dimension_set)
		_dimension_sets_container.add_child(tms_dimension_set)
