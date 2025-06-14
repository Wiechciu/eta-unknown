class_name StateData
extends Resource


var state: State
var value: float:
	set(new_value):
		value = clampf(new_value, state.min_value, state.max_value)


func initialize() -> void:
	GlobalTimer.new_day_started.connect(change_value.bind(state.regeneration_on_new_day))
	GlobalTimer.new_hour_started.connect(change_value.bind(state.regeneration_per_hour))


func change_value(change_amount: float) -> void:
	value += change_amount
