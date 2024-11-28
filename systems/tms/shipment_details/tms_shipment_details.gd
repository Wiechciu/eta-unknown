class_name TmsShipmentDetails
extends Control


var shipment: Shipment

@export var _tms: Tms

@export_category("Assigned internally")
@export var _tab_container: TabContainer
@export var _shipment_status: OptionButton

@export_group("References")
@export var _shipment_number: Label
@export var _customer_reference: Label

@export_group("Parties")
@export var _shipper: Label
@export var _consignee: Label

@export_group("Locations")
@export var _origin: Label
@export var _destination: Label

@export_group("Service")
@export var _incoterms: Label
@export var _service: Label

@export_group("Dates")
@export var _earliest_pickup: Label
@export var _latest_delivery: Label

@export_group("Shipment modules")
@export var _shipment_cargo_details: TmsShipmentDetailsCargoDetails
@export var _shipment_main_freight: TmsShipmentDetailsMainFreight
@export var _shipment_haulage: TmsShipmentDetailsHaulage
@export var _shipment_handling: TmsShipmentDetailsHandling
@export var _shipment_customs: TmsShipmentDetailsCustoms
@export var _shipment_events: TmsShipmentDetailsEvents
@export var _shipment_documentation: TmsShipmentDetailsDocumentation
@export var _shipment_accounting: TmsShipmentDetailsAccounting


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	for status: String in Shipment.Status.keys():
		_shipment_status.add_item(status)


func _on_visibility_changed() -> void:
	if not visible and shipment != null and shipment.details_changed.is_connected(refresh.unbind(1)):
		shipment.details_changed.disconnect(refresh.unbind(1))


func open_shipment_details(shipment_to_load: Shipment) -> void:
	load_shipment(shipment_to_load)
	shipment.details_changed.connect(refresh.unbind(1))
	_tab_container.current_tab = 0


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_shipment_status.select(shipment.status)
	
	_shipment_number.text = str(shipment.number)
	_customer_reference.text = shipment.customer_reference
	
	_shipper.text = shipment.shipper.print_string if shipment.shipper else ""
	_consignee.text = shipment.consignee.print_string if shipment.consignee else ""
	
	_origin.text = shipment.origin.print_string if shipment.origin else ""
	_destination.text = shipment.destination.print_string if shipment.destination else ""
	
	_incoterms.text = shipment.incoterms.print_string
	_service.text = shipment.service.name if shipment.service else ""
	
	_earliest_pickup.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.ERL))
	_latest_delivery.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.LTS))
	
	_shipment_cargo_details.load_shipment(shipment)
	_shipment_main_freight.load_shipment(shipment)
	_shipment_haulage.load_shipment(shipment)
	_shipment_handling.load_shipment(shipment)
	_shipment_customs.load_shipment(shipment)
	_shipment_events.load_shipment(shipment)
	_shipment_documentation.load_shipment(shipment)
	_shipment_accounting.load_shipment(shipment)


func _on_close_button_pressed() -> void:
	_tms.close_shipment_details()


func _on_shipment_statuses_item_selected(index: int) -> void:
	shipment.change_status(index)
