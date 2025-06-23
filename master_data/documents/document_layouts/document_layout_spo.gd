class_name ShippingOrder
extends DocumentLayout


@export_category("Assigned internally")
@export var _shipper: Label
@export var _consignee: Label
@export var _origin: Label
@export var _destination: Label
@export var _total_quantity: Label
@export var _total_weight: Label
@export var _total_volume: Label
@export var _dimension_sets_container: Control
@export var _document_dimension_set_scene: PackedScene


@warning_ignore("shadowed_variable_base_class")
func initialize(document: Document, custom_title: String = "") -> void:
	self.document = document
	self.custom_title = custom_title
	
	_shipper.text = document.shipment.shipper.print_string
	_consignee.text = document.shipment.consignee.print_string
	_origin.text = document.shipment.origin.print_string
	_destination.text = document.shipment.destination.print_string
	_total_quantity.text = str(document.shipment.cargo_details.total_quantity)
	_total_weight.text = str(document.shipment.cargo_details.total_weight)
	_total_volume.text = str(document.shipment.cargo_details.total_volume)
	
	clear_container()
	populate_container()
	initialized.emit()


func clear_container() -> void:
	for child: Node in _dimension_sets_container.get_children():
		child.queue_free()


func populate_container() -> void:
	for dimension_set: DimensionSet in document.shipment.cargo_details.dimension_sets:
		var document_dimension_set: DocumentDimensionSet = (_document_dimension_set_scene.instantiate() as DocumentDimensionSet).initialize(dimension_set)
		_dimension_sets_container.add_child(document_dimension_set)
