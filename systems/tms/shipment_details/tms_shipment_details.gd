class_name TmsShipmentDetails
extends Control


var shipment: Shipment

var tms: Tms

@export_category("Assigned internally")
@export var _tab_container: TabContainer
@export var _shipment_status: OptionButton

@export_group("References")
@export var _shipment_number: TmsField
@export var _customer_reference: TmsField

@export_group("Parties")
@export var _shipper: TmsField
@export var _consignee: TmsField

@export_group("Locations")
@export var _origin: TmsField
@export var _destination: TmsField

@export_group("Service")
@export var _incoterms: TmsField
@export var _service: TmsField

@export_group("Dates")
@export var _earliest_pickup: TmsField
@export var _latest_delivery: TmsField

@export_group("Shipment modules")
@export var _shipment_cargo_details: TmsShipmentDetailsCargoDetails
@export var _shipment_main_freight: TmsShipmentDetailsMainFreight
@export var _shipment_haulage: TmsShipmentDetailsHaulage
@export var _shipment_handling: TmsShipmentDetailsHandling
@export var _shipment_customs: TmsShipmentDetailsCustoms
@export var _shipment_events: TmsShipmentDetailsEvents
@export var _shipment_documentation: TmsShipmentDetailsDocumentation
@export var _shipment_accounting: TmsShipmentDetailsAccounting


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	tms = UtilityTools.get_parent_of_type(self, Tms) as Tms
	
	_shipment_status.clear()
	for status: String in Shipment.Status.keys():
		_shipment_status.add_item("SHIPMENT_STATUS_" + status.to_upper())


func close() -> void:
	visible = false
	if shipment != null and shipment.details_changed.is_connected(refresh.unbind(1)):
		shipment.details_changed.disconnect(refresh.unbind(1))


func open(shipment_to_load: Shipment) -> void:
	load_shipment(shipment_to_load)
	shipment.details_changed.connect(refresh.unbind(1))
	_tab_container.current_tab = 0
	visible = true


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_shipment_status.select(shipment.status)
	
	_shipment_number.value.text = str(shipment.number)
	_customer_reference.value.text = shipment.customer_reference
	
	_shipper.value.text = shipment.shipper.print_string if shipment.shipper else ""
	_consignee.value.text = shipment.consignee.print_string if shipment.consignee else ""
	
	_origin.value.text = shipment.origin.print_string if shipment.origin else ""
	_destination.value.text = shipment.destination.print_string if shipment.destination else ""
	
	_incoterms.value.text = shipment.incoterms.print_string
	_service.value.text = shipment.service.name if shipment.service else ""
	
	_earliest_pickup.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_code("ERL"))
	_latest_delivery.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_code("LTS"))
	
	_shipment_cargo_details.load_shipment(shipment)
	_shipment_main_freight.load_shipment(shipment)
	_shipment_haulage.load_shipment(shipment)
	_shipment_handling.load_shipment(shipment)
	_shipment_customs.load_shipment(shipment)
	_shipment_events.load_shipment(shipment)
	_shipment_documentation.load_shipment(shipment)
	_shipment_accounting.load_shipment(shipment)


func _on_close_button_pressed() -> void:
	tms.open_shipment_list()


func _on_shipment_statuses_item_selected(index: int) -> void:
	shipment.change_status(index)
