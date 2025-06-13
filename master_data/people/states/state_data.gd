class_name StateData
extends Resource


var state: State
var value: float:
	set(new_value):
		value = clampf(new_value, state.min_value, state.max_value)


func _init() -> void:
	GlobalTimer.new_day_started.connect(on_new_day_started)
	GlobalTimer.new_hour_started.connect(on_new_hour_started)


func on_new_day_started() -> void:
	value += state.regeneration_on_new_day


func on_new_hour_started() -> void:
	value += state.regeneration_per_hour
