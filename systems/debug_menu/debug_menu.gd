extends Control


@export var tms_scene: PackedScene
@export var fps: Label
@export var memory: Label
@export var status: Label
@export var shipping_order_scene: PackedScene

var counter: float


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	status.text = ""
	visible = false


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	fps.text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)
	memory.text = "Memory: %d / %d" % [Performance.get_monitor(Performance.MEMORY_STATIC) / 10**6, Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 10**6]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_console"):
		visible = not visible


func _on_new_shipping_order_button_pressed() -> void:
	var new_shipping_order: ShippingOrder = shipping_order_scene.instantiate()
	var new_shipment: Shipment = Shipment.new().with_data_random()
	if new_shipment == null:
		return
	new_shipping_order.load_shipment(Shipment.new().with_data_random())
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300
	status.text = "New shipping order created."


func _on_next_day_button_pressed() -> void:
	GlobalTimer.start_next_day()
	status.text = "Next day started."


func _on_new_request_for_quotation_button_pressed() -> void:
	@warning_ignore("unsafe_cast")
	var customer: Party = GlobalRefs.customers_with_employees.pick_random() as Party
	customer.create_new_request_for_quotation()
	status.text = "There are %s not awarded rfqs." % [GlobalRefs.requests_for_quotation_not_awarded.size()]


func _on_new_shipment_button_pressed() -> void:
	@warning_ignore("unsafe_cast")
	var customer: Party = GlobalRefs.customers_with_employees.pick_random() as Party
	if customer == null:
		return
	customer.create_new_shipment()
	status.text = "There are %s not owned shipments." % [GlobalRefs.shipments_not_owned.size()]


func _on_accept_new_shipment_button_pressed() -> void:
	if GameManager.player.person.employer == null:
		return
	accept_shipment()
	status.text = "Currently owns %s shipments.\nThere are %s not owned shipments left!" % [(GameManager.player.person.employer as Party).shipments.size(), GlobalRefs.shipments_not_owned.size()]


func _on_accept_10_new_shipments_button_pressed() -> void:
	if GameManager.player.person.employer == null:
		return
	
	for n: int in 10:
		if accept_shipment() == false:
			return
	status.text = "Currently owns %s shipments.\nThere are %s not owned shipments left!" % [(GameManager.player.person.employer as Party).shipments.size(), GlobalRefs.shipments_not_owned.size()]
	#print("Currently owns %s shipments. There are %s not owned shipments left!" % [GameManager.player_company.shipments.size(), GlobalRefs.shipments_not_owned.size()])


func accept_shipment() -> bool:
	if GameManager.player.person.employer == null:
		return false
	if not GlobalRefs.shipments_not_owned.is_empty():
		var random_shipment: Shipment = GlobalRefs.shipments_not_owned.pick_random()
		random_shipment.accept(GameManager.player.person.employer as Party)
		return true
	else:
		status.text = "Currently owns %s shipments.\nThere are no more shipments to accept!" % [(GameManager.player.person.employer as Party).shipments.size()]
		#print("Currently owns %s shipments. There are no more shipments to accept!" % [GameManager.player_company.shipments.size()])
		return false


func _on_send_quotation_to_request_button_pressed() -> void:
	if GameManager.player.person.employer == null:
		return
	
	if GlobalRefs.requests_for_quotation_not_awarded.is_empty():
		return
	
	@warning_ignore("unsafe_cast")
	var request_for_quotation: RequestForQuotation = GlobalRefs.requests_for_quotation_not_awarded.pick_random() as RequestForQuotation
	var quotation: Quotation = Quotation.new().with_data_random(request_for_quotation, GameManager.player.person.employer as Party)
	request_for_quotation.register_quotation(quotation)
	quotation.change_status(Quotation.Status.SUBMITTED)
	status.text = "Quotation submitted."


func _on_send_10_quotations_to_requests_button_pressed() -> void:
	for n: int in 10:
		_on_send_quotation_to_request_button_pressed()


func _on_next_month_button_pressed() -> void:
	if GameManager.player.person.employer == null:
		return
	
	GlobalTimer.start_next_month()
	status.text = "Next month started."


func _on_saving_test_case_button_pressed() -> void:
	SaveManager.start_new_game()
	await get_tree().process_frame
	GlobalTimer.start_next_day()
	await get_tree().process_frame
	_on_accept_10_new_shipments_button_pressed()
	await get_tree().process_frame
	SaveManager.save_game()
	await get_tree().process_frame
	SaveManager.load_game()
