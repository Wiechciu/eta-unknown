class_name State
extends Resource


var state_data: StateDataNew
var value: float:
	set(new_value):
		value = clampf(new_value, state_data.min_value, state_data.max_value)


func initialize() -> void:
	GlobalTimer.new_day_started.connect(change_value.bind(state_data.regeneration_on_new_day))
	GlobalTimer.new_hour_started.connect(change_value.bind(state_data.regeneration_per_hour))


func change_value(change_amount: float) -> void:
	value += change_amount
