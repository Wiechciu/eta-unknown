class_name TmsShipmentDetailsAccounting
extends PanelContainer


var shipment: Shipment

@export var _quotation: Label
@export var _revenue_total: Label
@export var _cost_total: Label
@export var _gross_profit: Label
@export var _margin: Label
@export var _revenue_container: Control
@export var _cost_container: Control
@export var _charge_scene: PackedScene


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func _on_visibility_changed() -> void:
	if visible and shipment:
		refresh()
	
	if not visible and shipment != null and shipment.accounting.charges_updated.is_connected(refresh):
		shipment.accounting.charges_updated.disconnect(refresh)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	if not shipment.accounting.charges_updated.is_connected(refresh):
		shipment.accounting.charges_updated.connect(refresh)
	
	_quotation.text = shipment.accounting.quotation.number if shipment.accounting.quotation else ""
	_revenue_total.text = shipment.accounting.revenue_charges_sum_string
	_cost_total.text = shipment.accounting.cost_charges_sum_string
	_gross_profit.text = shipment.accounting.gross_profit_string
	_margin.text = shipment.accounting.margin_string
	
	refresh_charges(_revenue_container, shipment.accounting.revenue_charges_as_charges)
	refresh_charges(_cost_container, shipment.accounting.cost_charges_as_charges)


func refresh_charges(charge_container: Control, charges: Array[Charge]) -> void:
	for child: Node in charge_container.get_children():
		child.queue_free()
	
	for charge: Charge in charges:
		var tms_charge: TmsCharge = (_charge_scene.instantiate() as TmsCharge).with_data(charge)
		charge_container.add_child(tms_charge)
