extends Control


@export var fps: Label
@export var memory: Label
@export var shipping_order_scene: PackedScene

var counter: float


func _process(delta: float) -> void:
	#counter += delta
	#if counter < 1:
		#return
	#counter = 0
	fps.text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)
	memory.text = "Memory: %d / %d" % [Performance.get_monitor(Performance.MEMORY_STATIC) / 10**6, Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 10**6]


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


func _on_new_request_for_quotation_button_pressed() -> void:
	var customer: Customer = GlobalRefs.customers_with_employees.pick_random() as Customer
	customer.create_new_request_for_quotation()


func _on_new_shipment_button_pressed() -> void:
	var customer: Customer = GlobalRefs.customers_with_employees.pick_random() as Customer
	customer.create_new_shipment()


func _on_accept_new_shipment_button_pressed() -> void:
	accept_shipment()


func _on_accept_10_new_shipments_button_pressed() -> void:
	for n: int in 10:
		if accept_shipment() == false:
			return
	print("There are %s not owned shipments left!" % GlobalRefs.shipments_not_owned.size())


func accept_shipment() -> bool:
	if not GlobalRefs.shipments_not_owned.is_empty():
		var random_shipment: Shipment = GlobalRefs.shipments_not_owned.pick_random()
		random_shipment.accept(GameManager.player_company as FreightForwarder)
		return true
	else:
		print("There are no more shipments to accept!")
		return false


func _on_send_quotation_to_request_button_pressed() -> void:
	var request_for_quotation: RequestForQuotation = GlobalRefs.requests_for_quotation_not_awarded.pick_random() as RequestForQuotation
	var quotation: Quotation = Quotation.new().with_data(request_for_quotation, GameManager.player_company)
	request_for_quotation.register_quotation(quotation)
	quotation.change_status(Quotation.Status.SUBMITTED)
