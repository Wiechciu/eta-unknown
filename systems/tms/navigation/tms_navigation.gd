class_name TmsNavigation
extends PanelContainer


@export var _tms: Tms
@export var _toggle_navigation_button: Button
@export var _panels_to_hide: Array[Control]
@export var header: Control
@export var hide_nav_texture: Texture
@export var show_nav_texture: Texture

var is_open: bool


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	open()


func open() -> void:
	if is_open:
		return
	
	is_open = true
	_toggle_navigation_button.icon = hide_nav_texture
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_method(func(value: float) -> void: header.custom_minimum_size.x = value, 50, 350, 0.2)
	#await tween.finished
	
	for panel: Control in _panels_to_hide:
		panel.show()


func close() -> void:
	if not is_open:
		return
	
	is_open = false
	_toggle_navigation_button.icon = show_nav_texture
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_method(func(value: float) -> void: header.custom_minimum_size.x = value, 350, 50, 0.2)
	await tween.finished
	
	for panel: Control in _panels_to_hide:
		panel.hide()


func _on_toggle_navigation_button_pressed() -> void:
	if is_open:
		close()
	else:
		open()

func _on_navigation_shipments_button_pressed() -> void:
	_tms.open_shipment_list()


func _on_navigation_quotations_button_pressed() -> void:
	_tms.open_quotation_list()


func _on_data_button_pressed() -> void:
	_tms.open_data()
