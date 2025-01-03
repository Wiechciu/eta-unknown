class_name TmsShipmentDetailsCargoDetails
extends PanelContainer


var shipment: Shipment

@export var _description: TmsField
@export var _total_quantity: TmsField
@export var _total_weight: TmsField
@export var _total_volume: TmsField
@export var _dimension_sets_container: Control
@export var _tms_dimension_set_scene: PackedScene


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_description.value.text = shipment.cargo_details.cargo.description if shipment.cargo_details.cargo else ""
	_total_quantity.value.text = "%d pcs" % [shipment.cargo_details.total_quantity]
	_total_weight.value.text = "%d kg" % [shipment.cargo_details.total_weight]
	_total_volume.value.text = "%.3f cbm" % [shipment.cargo_details.total_volume]

	for child: Node in _dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set: DimensionSet in shipment.cargo_details.dimension_sets:
		var tms_dimension_set: TmsDimensionSet = (_tms_dimension_set_scene.instantiate() as TmsDimensionSet).with_data(dimension_set)
		_dimension_sets_container.add_child(tms_dimension_set)
