class_name ShipmentListItem
extends Button


@export var shipment_details_scene: PackedScene
var shipment: Shipment


func with_data(new_shipment: Shipment) -> ShipmentListItem:
	shipment = new_shipment
	text = str(new_shipment.shipment_id) + " | " + new_shipment.origin.code + " -> " + new_shipment.destination.code
	return self


func _on_pressed() -> void:
	var new_shipment_details: ShipmentDetails = shipment_details_scene.instantiate()
	new_shipment_details.shipment = shipment
	new_shipment_details.name = "ShipmentDetails_" + str(shipment.shipment_id)
	
	get_tree().root.add_child(new_shipment_details)
	new_shipment_details.position.x = 300
