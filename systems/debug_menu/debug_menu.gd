extends Control


@export var shipping_order_scene: PackedScene


func _on_new_shipping_order_button_pressed() -> void:
	var new_shipping_order: ShippingOrder = shipping_order_scene.instantiate()
	var new_shipment: Shipment = Shipment.new().with_data()
	if new_shipment == null:
		return
	new_shipping_order.load_shipment(Shipment.new().with_data())
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300


func _on_next_day_button_pressed() -> void:
	GlobalTimer.start_next_day()


func _on_accept_new_shipment_button_pressed() -> void:
	accept_shipment()


func _on_accept_10_new_shipments_button_pressed() -> void:
	for n: int in 10:
		if accept_shipment() == false:
			return
	print("There are %s not owned shipments left!" % Shipment.all_not_owned.size())


func accept_shipment() -> bool:
	if not Shipment.all_not_owned.is_empty():
		var random_shipment: Shipment = Shipment.all_not_owned.pick_random()
		random_shipment.accept(GameManager.player.employer as FreightForwarder)
		return true
	else:
		print("There are no more shipments to accept!")
		return false
