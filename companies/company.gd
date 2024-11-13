class_name Company
extends Resource


signal new_shipment_accepted(Shipment)
signal shipment_completed(Shipment)
signal shipment_list_updated


@export var party_details: Party
@export var shipments: Array[Shipment]


func add_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment.completed.connect(_on_shipment_completed)
	new_shipment_accepted.emit(new_shipment)
	shipment_list_updated.emit()


func _on_shipment_completed(shipment: Shipment):
	shipment_completed.emit(shipment)
	shipment_list_updated.emit()
