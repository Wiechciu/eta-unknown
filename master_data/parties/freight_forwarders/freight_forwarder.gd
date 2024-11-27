class_name FreightForwarder
extends Party


signal new_shipment_accepted(shipment: Shipment)
signal shipment_status_changed(shipment: Shipment)
signal shipment_details_changed(shipment: Shipment)
signal shipment_list_updated


var shipments: Array[Shipment]
var last_shipment_number: int = 1000000
var total_earnings: float


func accept_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment.status_changed.connect(_on_shipment_status_changed)
	new_shipment.details_changed.connect(_on_shipment_details_changed)
	new_shipment_accepted.emit(new_shipment)
	shipment_list_updated.emit()


func _on_shipment_status_changed(shipment: Shipment) -> void:
	shipment_status_changed.emit(shipment)
	shipment_list_updated.emit()


func _on_shipment_details_changed(shipment: Shipment) -> void:
	shipment_details_changed.emit(shipment)
	shipment_list_updated.emit()


func get_next_shipment_number() -> int:
	last_shipment_number += 1
	return last_shipment_number
