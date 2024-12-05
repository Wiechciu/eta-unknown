class_name Tms
extends OsApp


@export var panel_header: TmsPanelHeader

@export var loading_screen: TmsLoadingScreen
@export var navigation: TmsNavigation

@export var shipment_list: TmsShipmentList
@export var shipment_details: TmsShipmentDetails
#@export var quotation_list: TmsQuotationList
#@export var quotation_details: TmsQuotationDetails


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	panel_header.close_button_pressed.connect(close)
	loading_screen.start_loading()
	close_all()


func close_all() -> void:
	shipment_list.close()
	shipment_details.close()
	#quotation_list.close()


func open_shipment_details(shipment: Shipment) -> void:
	close_all()
	shipment_details.open(shipment)


func open_shipment_list() -> void:
	close_all()
	shipment_list.open()


func open_quotation_list() -> void:
	close_all()
	#quotation_list.open()


func open_quotation_details(quotation: Quotation) -> void:
	close_all()
	#quotation_details.open(quotation)
