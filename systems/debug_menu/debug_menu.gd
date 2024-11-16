extends Control


@export var shipping_order_scene: PackedScene


func _on_new_shipping_order_button_pressed() -> void:
	var new_shipping_order = shipping_order_scene.instantiate()
	new_shipping_order.name = "ShippingOrder_" + str(Document.documents.size())
	(new_shipping_order as ShippingOrder).load_shipment(Shipment.new_random_shipment())
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300


func _on_next_day_button_pressed() -> void:
	GlobalTimer.start_next_day()
