extends Control


@export var shipping_order_scene: PackedScene


func _on_new_shipping_order_button_pressed() -> void:
	var new_shipping_order = shipping_order_scene.instantiate()
	new_shipping_order.name = "ShippingOrder_" + str(Document.documents.size())
	(new_shipping_order as ShippingOrder).load_shipment(Shipment.create_new())
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300


func _on_next_day_button_pressed() -> void:
	GlobalTimer.start_next_day()


func _on_accept_new_shipment_button_pressed() -> void:
	create_new_shipment_and_accept()


func _on_accept_10_new_shipments_button_pressed() -> void:
	for n in 10:
		create_new_shipment_and_accept()


func create_new_shipment_and_accept() -> void:
	Shipment.create_new().accept(GameManager.player.employer)
