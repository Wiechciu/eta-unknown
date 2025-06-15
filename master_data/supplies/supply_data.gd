class_name SupplyData
extends Resource


@export var supply_name: String
@export var amount_per_use: float = 1.0
@export var amount_capacity: float = 100.0
@export var refilling_time: float = 3.0

@export var out_of_supply_streams: Array[AudioStream]
@export var refilling_supply_streams: Array[AudioStream]
