class_name ShipmentDetails
extends Control


var shipment: Shipment

@export var tms: Tms

@export_category("Assigned internally")
@export var tab_container: TabContainer

@export_group("References")
@export var shipment_number: Label
@export var customer_reference: Label

@export_group("Parties")
@export var shipper: Label
@export var consignee: Label

@export_group("Locations")
@export var origin: Label
@export var destination: Label

@export_group("Service")
@export var incoterms: Label
@export var service: Label

@export_group("Dates")
@export var earliest_pickup: Label
@export var latest_delivery: Label

@export_group("Cargo details")
@export var cargo_description: Label
@export var slac: Label
@export var total_quantity: Label
@export var total_weight: Label
@export var total_volume: Label
@export var dimension_sets_container: Control
@export var document_dimension_set_scene: PackedScene


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	shipment_number.text = str(shipment.shipment_number)
	customer_reference.text = shipment.customer_reference
	
	shipper.text = shipment.shipper.print_string
	consignee.text = shipment.consignee.print_string
	
	origin.text = shipment.origin.print_string
	destination.text = shipment.destination.print_string
	
	incoterms.text = shipment.incoterms_full
	service.text = shipment.service.name
	
	earliest_pickup.text = Time.get_datetime_string_from_unix_time(shipment.earliest_pickup_date).replace("T", ", ").left(-3)
	latest_delivery.text = Time.get_datetime_string_from_unix_time(shipment.latest_delivery_date).replace("T", ", ").left(-3)
	
	cargo_description.text = shipment.cargo.description
	slac.text = str(shipment.slac)
	total_quantity.text = str(shipment.total_quantity)
	total_weight.text = str(shipment.total_weight)
	total_volume.text = str(shipment.total_volume)
	
	for child in dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set in shipment.dimension_sets:
		var document_dimension_set: DocumentDimensionSet = document_dimension_set_scene.instantiate()
		document_dimension_set.quantity.text = str(dimension_set.quantity)
		document_dimension_set.length.text = str(dimension_set.length)
		document_dimension_set.width.text = str(dimension_set.width)
		document_dimension_set.height.text = str(dimension_set.height)
		document_dimension_set.total_weight.text = str(dimension_set.total_weight)
		dimension_sets_container.add_child(document_dimension_set)
	
	tab_container.current_tab = 0


func _on_complete_button_pressed() -> void:
	shipment.change_status(Shipment.Status.COMPLETED)
	tms.close_shipment_details()


func _on_close_button_pressed() -> void:
	tms.close_shipment_details()
