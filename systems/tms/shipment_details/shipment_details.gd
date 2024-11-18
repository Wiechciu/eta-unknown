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
@export var tms_dimension_set_scene: PackedScene

@export_group("Main freight")
@export var mode_of_transport: Label
@export var carrier: Label
@export var planned_departure: Label
@export var planned_arrival: Label

@export_group("Haulage")
@export var trucker_pickup: Label
@export var trucker_delivery: Label
@export var planned_pickup: Label
@export var planned_delivery: Label

@export_group("Handling")
@export var handling_agent_export: Label
@export var handling_agent_import: Label

@export_group("Customs")
@export var customs_agency_export: Label
@export var customs_agency_import: Label


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	shipment_number.text = str(shipment.shipment_number)
	customer_reference.text = shipment.customer_reference
	
	shipper.text = shipment.shipper.print_string if shipment.shipper else ""
	consignee.text = shipment.consignee.print_string if shipment.consignee else ""
	
	origin.text = shipment.origin.print_string if shipment.origin else ""
	destination.text = shipment.destination.print_string if shipment.destination else ""
	
	incoterms.text = shipment.incoterms_full
	service.text = shipment.service.name if shipment.service else ""
	
	earliest_pickup.text = GlobalTimer.get_nice_format_datetime_string(shipment.earliest_pickup_date)
	latest_delivery.text = GlobalTimer.get_nice_format_datetime_string(shipment.latest_delivery_date)
	
	cargo_description.text = shipment.cargo.description if shipment.cargo else ""
	slac.text = "%d pcs" % [shipment.slac]
	total_quantity.text = "%d pcs" % [shipment.total_quantity]
	total_weight.text = "%d kg" % [shipment.total_weight]
	total_volume.text = "%.3f cbm" % [shipment.total_volume]

	for child in dimension_sets_container.get_children():
		child.queue_free()
	for dimension_set in shipment.dimension_sets:
		var tms_dimension_set: TmsDimensionSet = (tms_dimension_set_scene.instantiate() as TmsDimensionSet).with_data(dimension_set)
		dimension_sets_container.add_child(tms_dimension_set)
	
	mode_of_transport.text = Shipment.ModeOfTransport.keys()[shipment.mode_of_transport] if shipment.mode_of_transport != Shipment.ModeOfTransport.NONE else ""
	carrier.text = shipment.carrier.name if shipment.carrier else ""
	planned_departure.text = GlobalTimer.get_nice_format_datetime_string(shipment.planned_departure_date)
	planned_arrival.text = GlobalTimer.get_nice_format_datetime_string(shipment.planned_arrival_date)

	trucker_pickup.text = shipment.trucker_pickup.name if shipment.trucker_pickup else ""
	trucker_delivery.text = shipment.trucker_delivery.name if shipment.trucker_delivery else ""
	planned_pickup.text = GlobalTimer.get_nice_format_datetime_string(shipment.planned_pickup_date)
	planned_delivery.text = GlobalTimer.get_nice_format_datetime_string(shipment.planned_delivery_date)
	
	handling_agent_export.text = shipment.handling_agent_export.name if shipment.handling_agent_export else ""
	handling_agent_import.text = shipment.handling_agent_import.name if shipment.handling_agent_import else ""
	
	customs_agency_export.text = shipment.customs_agency_export.name if shipment.customs_agency_export else ""
	customs_agency_import.text = shipment.customs_agency_import.name if shipment.customs_agency_import else ""
	
	tab_container.current_tab = 0


func _on_complete_button_pressed() -> void:
	shipment.change_status(Shipment.Status.COMPLETED)
	tms.close_shipment_details()


func _on_close_button_pressed() -> void:
	tms.close_shipment_details()
