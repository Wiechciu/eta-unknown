class_name Company
extends Resource


signal new_shipment_accepted(Shipment)


@export var party_details: Party
@export var shipments: Array[Shipment]


func add_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment_accepted.emit(new_shipment)
