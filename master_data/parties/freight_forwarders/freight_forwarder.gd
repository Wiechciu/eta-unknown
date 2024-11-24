class_name FreightForwarder
extends Party


signal new_shipment_accepted(Shipment)
signal shipment_status_changed(Shipment)
signal shipment_details_changed(Shipment)
signal shipment_list_updated


static var all_specific: Array[FreightForwarder]
static var all_specific_dict: Dictionary[String, FreightForwarder]
static var all_specific_with_employees: Array[FreightForwarder]:
	get:
		return all_specific.filter(Party.has_employees)


var shipments: Array[Shipment]
var last_shipment_number: int = 1000000
var total_earnings: float


func accept_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment.status_changed.connect(_on_shipment_status_changed)
	new_shipment.details_changed.connect(_on_shipment_details_changed)
	new_shipment_accepted.emit(new_shipment)
	shipment_list_updated.emit()


func _on_shipment_status_changed(shipment: Shipment):
	shipment_status_changed.emit(shipment)
	shipment_list_updated.emit()


func _on_shipment_details_changed(shipment: Shipment):
	shipment_details_changed.emit(shipment)
	shipment_list_updated.emit()


func get_next_shipment_number() -> int:
	last_shipment_number += 1
	return last_shipment_number
