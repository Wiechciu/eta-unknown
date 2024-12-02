class_name TmsNavigation
extends PanelContainer


@export var _tms: Tms
@export var _toggle_navigation_button: Button
@export var _panels_to_hide: Array[Control]

var is_open: bool


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	open()


func _on_navigation_shipments_button_pressed() -> void:
	_tms.open_shipment_list()


func _on_navigation_quotations_button_pressed() -> void:
	_tms.open_quotation_list()


func _on_toggle_navigation_button_pressed() -> void:
	if is_open:
		close()
	else:
		open()


func open() -> void:
	is_open = true
	_toggle_navigation_button.text = "<"
	for panel: Control in _panels_to_hide:
		panel.visible = true


func close() -> void:
	is_open = false
	_toggle_navigation_button.text = ">"
	for panel: Control in _panels_to_hide:
		panel.visible = false
