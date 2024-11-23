class_name ShipmentEvents
extends Resource


var shipment: Shipment
var events: Array[Event] #TODO
var earliest_pickup_date_time_event: TimeEvent
var latest_delivery_date_time_event: TimeEvent
var planned_pickup_date_time_event: TimeEvent
var planned_delivery_date_time_event: TimeEvent
var planned_departure_date_time_event: TimeEvent
var planned_arrival_date_time_event: TimeEvent


static func create_new(parent_shipment: Shipment) -> ShipmentEvents:
	var new_events := ShipmentEvents.new()
	new_events.shipment = parent_shipment
	
	return new_events


func create_time_events() -> void:
	earliest_pickup_date_time_event = GlobalTimer.create_time_event(shipment.earliest_pickup_date, self)
	latest_delivery_date_time_event = GlobalTimer.create_time_event(shipment.latest_delivery_date, self)


func notify(time_event: TimeEvent) -> void:
	match time_event:
		earliest_pickup_date_time_event:
			print_debug("Shipment ID %s: earliest_pickup_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
		latest_delivery_date_time_event:
			print_debug("Shipment ID %s: latest_delivery_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
		planned_pickup_date_time_event:
			print_debug("Shipment ID %s: planned_pickup_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
		planned_delivery_date_time_event:
			print_debug("Shipment ID %s: planned_delivery_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
		planned_departure_date_time_event:
			print_debug("Shipment ID %s: planned_departure_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
		planned_arrival_date_time_event:
			print_debug("Shipment ID %s: planned_arrival_date_time_event (%s)" % [shipment.shipment_id, time_event.time])
