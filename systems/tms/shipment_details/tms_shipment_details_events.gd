class_name TmsShipmentDetailsEvents
extends PanelContainer


var shipment: Shipment

@export var _planned_event_details_container: Control
@export var _actual_event_details_container: Control
@export var _event_details_scene: PackedScene


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func _on_visibility_changed() -> void:
	if visible and shipment:
		refresh()
	
	if not visible and shipment != null and shipment.events.events_updated.is_connected(refresh):
		shipment.events.events_updated.disconnect(refresh)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	if not shipment.events.events_updated.is_connected(refresh):
		shipment.events.events_updated.connect(refresh)
	
	refresh_event_details(_planned_event_details_container, shipment.events.planned_events_as_events)
	refresh_event_details(_actual_event_details_container, shipment.events.actual_events_as_events)


func refresh_event_details(event_details_container: Control, events: Array[Event]) -> void:
	for child in event_details_container.get_children():
		child.queue_free()
	
	for event in events:
		var event_details: TmsEventDetails = (_event_details_scene.instantiate() as TmsEventDetails).with_data(event)
		event_details_container.add_child(event_details)
