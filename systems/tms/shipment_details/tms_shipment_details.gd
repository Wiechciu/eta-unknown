class_name TmsShipmentDetails
extends Control


var shipment: Shipment

@export var tms: Tms

@export_category("Assigned internally")
@export var tab_container: TabContainer
@export var shipment_status: OptionButton

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

@export_group("Shipment modules")
@export var shipment_cargo_details: TmsShipmentDetailsCargoDetails
@export var shipment_main_freight: TmsShipmentDetailsMainFreight
@export var shipment_haulage: TmsShipmentDetailsHaulage
@export var shipment_handling: TmsShipmentDetailsHandling
@export var shipment_customs: TmsShipmentDetailsCustoms
@export var shipment_events: TmsShipmentDetailsEvents


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
	
	for status: String in Shipment.Status.keys():
		self.shipment_status.add_item(status)


func _on_visibility_changed() -> void:
	if not visible and shipment != null and shipment.details_changed.is_connected(refresh.unbind(1)):
		shipment.details_changed.disconnect(refresh.unbind(1))


func open_shipment_details(shipment_to_load: Shipment) -> void:
	load_shipment(shipment_to_load)
	shipment.details_changed.connect(refresh.unbind(1))
	tab_container.current_tab = 0


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	shipment_status.select(shipment.status)
	
	shipment_number.text = str(shipment.shipment_number)
	customer_reference.text = shipment.customer_reference
	
	shipper.text = shipment.shipper.print_string if shipment.shipper else ""
	consignee.text = shipment.consignee.print_string if shipment.consignee else ""
	
	origin.text = shipment.origin.print_string if shipment.origin else ""
	destination.text = shipment.destination.print_string if shipment.destination else ""
	
	incoterms.text = shipment.incoterms.print_string
	service.text = shipment.service.name if shipment.service else ""
	
	earliest_pickup.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.ERL))
	latest_delivery.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.LTS))
	
	shipment_cargo_details.load_shipment(shipment)
	shipment_main_freight.load_shipment(shipment)
	shipment_haulage.load_shipment(shipment)
	shipment_handling.load_shipment(shipment)
	shipment_customs.load_shipment(shipment)
	shipment_events.load_shipment(shipment)


func _on_close_button_pressed() -> void:
	tms.close_shipment_details()


func _on_shipment_statuses_item_selected(index: int) -> void:
	shipment.change_status(index)
