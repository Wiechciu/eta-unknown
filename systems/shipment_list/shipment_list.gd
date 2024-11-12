class_name ShipmentList
extends Control


@export var _shipment_container: Control


func _ready() -> void:
	for child in _shipment_container.get_children():
		child.queue_free()
	GameManager.player.employer.new_shipment_accepted.connect(add_shipment)


func add_shipment(new_shipment: Shipment) -> void:
	var new_shipment_label = Label.new()
	new_shipment_label.text = new_shipment.origin.code + " -> " + new_shipment.destination.code
	_shipment_container.add_child(new_shipment_label)
	
