class_name ShipmentListItem
extends Control


signal pressed_with_shipment_data(Shipment)


var shipment: Shipment

@export var shipment_details_scene: PackedScene

@export var shipment_number: Label
@export var shipper: Label
@export var origin: Label
@export var destination: Label
@export var total_weight: Label
@export var status: Label


func with_data(new_shipment: Shipment) -> ShipmentListItem:
	shipment = new_shipment
	
	shipment_number.text = str(shipment.shipment_number)
	shipper.text = shipment.shipper.name
	origin.text = shipment.origin.code
	destination.text = shipment.destination.code
	total_weight.text = str(shipment.total_weight)
	status.text = Shipment.Status.keys()[shipment.status]
	match shipment.status:
		Shipment.Status.COMPLETED:
			modulate = Color.LIGHT_GREEN
	return self


func _on_button_pressed() -> void:
	pressed_with_shipment_data.emit(shipment)


#func _on_pressed() -> void:
	#var new_shipment_details: ShipmentDetails = shipment_details_scene.instantiate()
	#new_shipment_details.load_shipment(shipment)
	#new_shipment_details.name = "ShipmentDetails_" + str(shipment.shipment_id)
	#
	#get_tree().root.add_child(new_shipment_details)
	#new_shipment_details.position.x = 300
