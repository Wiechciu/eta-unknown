class_name TmsShipmentDetailsAccounting
extends PanelContainer


var shipment: Shipment

@export var _quotation: TmsField
@export var _revenue_total: TmsField
@export var _cost_total: TmsField
@export var _gross_profit: TmsField
@export var _margin: TmsField
@export var _revenue_container: Control
@export var _cost_container: Control
@export var _charge_scene: PackedScene


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


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
	
	_quotation.value.text = shipment.accounting.quotation.number if shipment.accounting.quotation else ""
	_revenue_total.value.text = shipment.accounting.revenue_charges_sum_string
	_cost_total.value.text = shipment.accounting.cost_charges_sum_string
	_gross_profit.value.text = shipment.accounting.gross_profit_string
	_margin.value.text = shipment.accounting.margin_string
	
	refresh_charges(_revenue_container, shipment.accounting.revenue_charges)
	refresh_charges(_cost_container, shipment.accounting.cost_charges)


func refresh_charges(charge_container: Control, charges: Array[Charge]) -> void:
	for child: Node in charge_container.get_children():
		child.queue_free()
	
	for charge: Charge in charges:
		var tms_charge: TmsCharge = (_charge_scene.instantiate() as TmsCharge).with_data(charge)
		charge_container.add_child(tms_charge)
