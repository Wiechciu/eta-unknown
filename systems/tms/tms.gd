class_name Tms
extends Control


@export var shipment_list: TmsShipmentList
@export var shipment_details: TmsShipmentDetails


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	close_shipment_details()


func open_shipment_details(shipment: Shipment) -> void:
	shipment_details.open_shipment_details(shipment)
	
	shipment_list.visible = false
	shipment_details.visible = true


func close_shipment_details() -> void:
	shipment_list.visible = true
	shipment_details.visible = false
