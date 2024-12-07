extends Control


@export var tms_scene: PackedScene
@export var fps: Label
@export var memory: Label
@export var status: Label
@export var shipping_order_scene: PackedScene

var counter: float


func _ready() -> void:
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
	var new_shipment: Shipment = Shipment.new().with_data()
	if new_shipment == null:
		return
	new_shipping_order.load_shipment(Shipment.new().with_data())
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300
	status.text = "New shipping order created."


func _on_next_day_button_pressed() -> void:
	GlobalTimer.start_next_day()
	status.text = "Next day started."


func _on_new_request_for_quotation_button_pressed() -> void:
	@warning_ignore("unsafe_cast")
	var customer: Customer = GlobalRefs.customers_with_employees.pick_random() as Customer
	customer.create_new_request_for_quotation()
	status.text = "There are %s not awarded rfqs." % [GlobalRefs.requests_for_quotation_not_awarded.size()]


func _on_new_shipment_button_pressed() -> void:
	@warning_ignore("unsafe_cast")
	var customer: Customer = GlobalRefs.customers_with_employees.pick_random() as Customer
	customer.create_new_shipment()
	status.text = "There are %s not owned shipments." % [GlobalRefs.shipments_not_owned.size()]


func _on_accept_new_shipment_button_pressed() -> void:
	accept_shipment()
	status.text = "Currently owns %s shipments.\nThere are %s not owned shipments left!" % [GameManager.player_company.shipments.size(), GlobalRefs.shipments_not_owned.size()]


func _on_accept_10_new_shipments_button_pressed() -> void:
	for n: int in 10:
		if accept_shipment() == false:
			return
	status.text = "Currently owns %s shipments.\nThere are %s not owned shipments left!" % [GameManager.player_company.shipments.size(), GlobalRefs.shipments_not_owned.size()]
	#print("Currently owns %s shipments. There are %s not owned shipments left!" % [GameManager.player_company.shipments.size(), GlobalRefs.shipments_not_owned.size()])


func accept_shipment() -> bool:
	if not GlobalRefs.shipments_not_owned.is_empty():
		var random_shipment: Shipment = GlobalRefs.shipments_not_owned.pick_random()
		random_shipment.accept(GameManager.player_company as FreightForwarder)
		return true
	else:
		status.text = "Currently owns %s shipments.\nThere are no more shipments to accept!" % [GameManager.player_company.shipments.size()]
		#print("Currently owns %s shipments. There are no more shipments to accept!" % [GameManager.player_company.shipments.size()])
		return false


func _on_send_quotation_to_request_button_pressed() -> void:
	@warning_ignore("unsafe_cast")
	var request_for_quotation: RequestForQuotation = GlobalRefs.requests_for_quotation_not_awarded.pick_random() as RequestForQuotation
	var quotation: Quotation = Quotation.new().with_data(request_for_quotation, GameManager.player_company)
	request_for_quotation.register_quotation(quotation)
	quotation.change_status(Quotation.Status.SUBMITTED)
	status.text = "Quotation submitted."


func _on_send_10_quotations_to_requests_button_pressed() -> void:
	for n: int in 10:
		_on_send_quotation_to_request_button_pressed()
