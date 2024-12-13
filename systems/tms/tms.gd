class_name Tms
extends OsApp


@export var all_container: BoxContainer
@export var panel_header: TmsPanelHeader

@export var loading_screen: TmsLoadingScreen
@export var navigation: TmsNavigation

@export var shipment_list: TmsShipmentList
@export var shipment_details: TmsShipmentDetails
#@export var quotation_list: TmsQuotationList
#@export var quotation_details: TmsQuotationDetails


func _ready() -> void:
	super._ready()
	panel_header.close_button_pressed.connect(close)
	panel_header.minimize_button_pressed.connect(minimize)
	shipment_details._shipment_documentation.document_print_ordered.connect(_on_document_print_ordered)
	
	close_all_except_navigation()
	hide_all()
	super.start()
	loading_screen.start_loading()
	await loading_screen.finished_loading
	show_all()


func close_all() -> void:
	navigation.close()
	close_all_except_navigation()


func close_all_except_navigation() -> void:
	shipment_list.close()
	shipment_details.close()
	#quotation_list.close()


func hide_all() -> void:
	all_container.hide()


func show_all() -> void:
	all_container.show()


func open_shipment_details(shipment: Shipment) -> void:
	close_all()
	shipment_details.open(shipment)


func open_shipment_list() -> void:
	close_all()
	shipment_list.open()


func open_quotation_list() -> void:
	close_all()
	#quotation_list.open()


@warning_ignore("unused_parameter")
func open_quotation_details(quotation: Quotation) -> void:
	close_all()
	#quotation_details.open(quotation)


func _on_document_print_ordered(document: Document) -> void:
	document_print_ordered.emit(document)
