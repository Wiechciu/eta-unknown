class_name TmsShipmentDetailsHandling
extends PanelContainer


var shipment: Shipment
@export var _handling_agent_export: Label
@export var _handling_agent_import: Label

@export var _arrange_export_handling_button: Button
@export var _arrange_import_handling_button: Button


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
	
	_arrange_export_handling_button.pressed.connect(_on_arrange_export_handling_button_pressed)
	_arrange_import_handling_button.pressed.connect(_on_arrange_import_handling_button_pressed)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	_handling_agent_export.text = shipment.handling.handling_agent_export.name if shipment.handling.handling_agent_export else ""
	_handling_agent_import.text = shipment.handling.handling_agent_import.name if shipment.handling.handling_agent_import else ""


func _on_arrange_export_handling_button_pressed() -> void:
	shipment.handling.handling_agent_export = GlobalRefs.handling_agents.pick_random()
	refresh()


func _on_arrange_import_handling_button_pressed() -> void:
	shipment.handling.handling_agent_import = GlobalRefs.handling_agents.pick_random()
	refresh()
