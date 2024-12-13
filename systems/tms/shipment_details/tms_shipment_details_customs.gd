class_name TmsShipmentDetailsCustoms
extends PanelContainer


var shipment: Shipment
@export var _customs_agency_export: TmsField
@export var _customs_agency_import: TmsField
@export var _export_customs_cleared_date: TmsField
@export var _import_customs_cleared_date: TmsField

@export var _arrange_export_customs_button: Button
@export var _arrange_import_customs_button: Button


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	
	_arrange_export_customs_button.pressed.connect(_on_arrange_export_customs_button_pressed)
	_arrange_import_customs_button.pressed.connect(_on_arrange_import_customs_button_pressed)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_customs_agency_export.value.text = shipment.customs.customs_agency_export.name if shipment.customs.customs_agency_export else ""
	_customs_agency_import.value.text = shipment.customs.customs_agency_import.name if shipment.customs.customs_agency_import else ""
	_export_customs_cleared_date.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.CSE))
	_import_customs_cleared_date.value.text = GlobalTimer.get_nice_datetime_string_from_event(shipment.events.get_first_event_of_type(Event.Code.CSI))



func _on_arrange_export_customs_button_pressed() -> void:
	shipment.customs.customs_agency_export = GlobalRefs.customs_agencies.pick_random()
	shipment.events.create_new_planned_event(Event.Code.CSE, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.RCV), 1, 8))
	refresh()


func _on_arrange_import_customs_button_pressed() -> void:
	shipment.customs.customs_agency_import = GlobalRefs.customs_agencies.pick_random()
	shipment.events.create_new_planned_event(Event.Code.CSI, GlobalTimer.get_future_date_from_event(shipment.events.get_first_event_of_type(Event.Code.ARR), 0, 20))
	refresh()
