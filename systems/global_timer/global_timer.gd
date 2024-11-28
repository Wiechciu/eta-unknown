extends Node


signal new_day_started
signal shift_started
signal shift_ended
signal lunch_started
signal lunch_ended


const ONE_SECOND: int = 1
const ONE_MINUTE: int = 1 * 60
const ONE_HOUR: int = 1 * 60 * 60
const ONE_DAY: int = 1 * 60 * 60 * 24
const ONE_WEEK: int = 1 * 60 * 60 * 24 * 7
const ONE_MONTH: int = 1 * 60 * 60 * 24 * 30 #FIXME - it's inaccurate and may cause issues
const ONE_YEAR: int = 1 * 60 * 60 * 24 * 365 #FIXME - it's inaccurate and may cause issues
const STARTING_DATE: String = "2025-01-01T08:00:00"

@export var time_scale: int = 600
@export var shift_start_hour: int = 8
@export var shift_end_hour: int = 16
@export var lunch_start_hour: int = 12
@export var lunch_end_hour: int = 13

var now_float: float
var now: int:
	get:
		return int(now_float)
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
var current_day: String
var time_events: Array[TimeEvent]


func _init() -> void:
	now_float = Time.get_unix_time_from_datetime_string(STARTING_DATE)


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func _process(delta: float) -> void:
	now_float += delta * time_scale
	_check_hour_change()
	_check_day_change()
	_check_time_events()

func _check_hour_change() -> void:
	var new_hour: int = time_dictionary["hour"]
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


func _check_day_change() -> void:
	var new_day: String = date_string
	if new_day == current_day:
		return
	
	current_day = new_day
	new_day_started.emit()
	print("New day started: " + new_day)


func start_next_day() -> void:
	var next_day_datetime_dictionary: Dictionary = Time.get_datetime_dict_from_unix_time(now + ONE_DAY)
	next_day_datetime_dictionary["hour"] = shift_start_hour
	next_day_datetime_dictionary["minute"] = 0
	now_float = Time.get_unix_time_from_datetime_dict(next_day_datetime_dictionary)


func get_future_date_from_unix_time(original_date: int, plus_days: int = 0, hour: int = 0, minute: int = 0) -> int:
	var datetime_dict: Dictionary = Time.get_date_dict_from_unix_time(original_date + ONE_DAY * plus_days)
	datetime_dict["hour"] = hour
	datetime_dict["minute"] = minute
	datetime_dict["second"] = 0
	return Time.get_unix_time_from_datetime_dict(datetime_dict)


func get_future_date_from_event(original_event: Event, plus_days: int = 0, hour: int = 0, minute: int = 0) -> int:
	if original_event == null:
		return -1
	var time: int = original_event.time if original_event else now
	return get_future_date_from_unix_time(time, plus_days, hour, minute)


func get_future_date_from_now(plus_days: int = 0, hour: int = 0, minute: int = 0) -> int:
	return get_future_date_from_unix_time(now, plus_days, hour, minute)


func get_nice_datetime_string_from_unix_time(unix_time: int) -> String:
	if unix_time == 0:
		return ""
	return Time.get_datetime_string_from_unix_time(unix_time).replace("T", ", ").left(-3)


func get_nice_datetime_string_from_event(event: Event) -> String:
	if event == null:
		return ""
	return get_nice_datetime_string_from_unix_time(event.time)


func get_nice_date_string_from_unix_time(unix_time: int) -> String:
	if unix_time == 0:
		return ""
	return Time.get_datetime_string_from_unix_time(unix_time).left(-9)


func get_nice_date_string_from_event(event: Event) -> String:
	if event == null:
		return ""
	return get_nice_date_string_from_unix_time(event.time)


func create_time_event_from_unix_time(time: int, observer: Object, event: Event = null) -> TimeEvent:
	var new_time_event: TimeEvent = TimeEvent.new().with_data(time, observer, event)
	time_events.append(new_time_event)
	time_events.sort_custom(_sort_time_events_ascending)
	return new_time_event


func create_time_event_from_event(event: Event, observer: Object) -> TimeEvent:
	if event == null:
		return null
	return create_time_event_from_unix_time(event.time, observer, event)



func _sort_time_events_ascending(a: TimeEvent, b: TimeEvent) -> bool:
	if a.time < b.time:
		return true
	return false


func _check_time_events() -> void:
	var counter: int = -1
	var time_event_indexes_to_remove: Array[int]
	for time_event: TimeEvent in time_events:
		counter += 1
		if time_event.time > now:
			break
		time_event.notify()
		time_event_indexes_to_remove.push_front(counter)
	
	for time_event_index_to_remove: int in time_event_indexes_to_remove:
		time_events.remove_at(time_event_index_to_remove)
