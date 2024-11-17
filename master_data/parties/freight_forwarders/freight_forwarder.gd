class_name FreightForwarder
extends Party


signal new_shipment_accepted(Shipment)
signal shipment_completed(Shipment)
signal shipment_list_updated


static var all_specific: Array[FreightForwarder]
static var all_specific_dict: Dictionary[String, FreightForwarder]
static var all_specific_with_employees: Array[FreightForwarder]:
	get:
		return all_specific.filter(Party.has_employees)


var shipments: Array[Shipment]
var last_shipment_number: int = 1000000


func add_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment.completed.connect(_on_shipment_completed)
	new_shipment_accepted.emit(new_shipment)
	shipment_list_updated.emit()


func _on_shipment_completed(shipment: Shipment):
	shipment_completed.emit(shipment)
	shipment_list_updated.emit()


func get_next_shipment_number() -> int:
	last_shipment_number += 1
	return last_shipment_number
