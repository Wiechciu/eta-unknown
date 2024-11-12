extends Node


signal shift_started
signal shift_ended
signal lunch_started
signal lunch_ended


@export var time_scale: float = 600
@export var shift_start_hour: int = 8
@export var shift_end_hour: int = 16
@export var lunch_start_hour: int = 12
@export var lunch_end_hour: int = 13


@export var timer: float
@export var date_string: String:
	get:
		return Time.get_date_string_from_unix_time(timer)
@export var time_string: String:
	get:
		return Time.get_time_string_from_unix_time(timer)
@export var time_dictionary: Dictionary:
	get:
		return Time.get_datetime_dict_from_unix_time(timer)

var current_hour: int


func _init() -> void:
	timer = Time.get_unix_time_from_datetime_string("2025-01-01T08:00:00")


func _process(delta: float) -> void:
	timer += delta * time_scale
	check_timesplits()


func check_timesplits() -> void:
	var new_hour = time_dictionary["hour"]
	if new_hour == current_hour:
		return
	
	if new_hour == shift_start_hour:
		shift_started.emit()
	if new_hour == shift_end_hour:
		shift_ended.emit()
	if new_hour == lunch_start_hour:
		lunch_started.emit()
	if new_hour == lunch_end_hour:
		lunch_ended.emit()
	
	current_hour = new_hour
