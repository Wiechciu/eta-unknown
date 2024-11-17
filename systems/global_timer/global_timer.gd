extends Node


signal shift_started
signal shift_ended
signal lunch_started
signal lunch_ended


const ONE_SECOND: int = 1
const ONE_MINUTE: int = 1 * 60
const ONE_HOUR: int = 1 * 60 * 60
const ONE_DAY: int = 1 * 60 * 60 * 24
const ONE_WEEK: int = 1 * 60 * 60 * 24 * 7
const ONE_MONTH: int = 1 * 60 * 60 * 24 * 30
const ONE_YEAR: int = 1 * 60 * 60 * 24 * 365
const STARTING_DATE: String = "2025-01-01T08:00:00"

@export var time_scale: float = 600
@export var shift_start_hour: int = 8
@export var shift_end_hour: int = 16
@export var lunch_start_hour: int = 12
@export var lunch_end_hour: int = 13

var now: float
var date_string: String:
	get:
		return Time.get_date_string_from_unix_time(now)
var time_string: String:
	get:
		return Time.get_time_string_from_unix_time(now)
var time_dictionary: Dictionary:
	get:
		return Time.get_datetime_dict_from_unix_time(now)

var current_hour: int


func _init() -> void:
	now = Time.get_unix_time_from_datetime_string(STARTING_DATE)


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


func _process(delta: float) -> void:
	now += delta * time_scale
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


func start_next_day() -> void:
	var next_day_time_dictionary = Time.get_datetime_dict_from_unix_time(now + ONE_DAY)
	next_day_time_dictionary["hour"] = shift_start_hour
	next_day_time_dictionary["minute"] = 0
	now = Time.get_unix_time_from_datetime_dict(next_day_time_dictionary)


func get_future_date(original_date: int, plus_days: int, hour: int, minute: int) -> int:
	var datetime_dict = Time.get_date_dict_from_unix_time(original_date + ONE_DAY * plus_days)
	datetime_dict["hour"] = hour
	datetime_dict["minute"] = minute
	datetime_dict["second"] = 0
	return Time.get_unix_time_from_datetime_dict(datetime_dict)
