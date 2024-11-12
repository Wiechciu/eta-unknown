extends Node


@export var time_scale: float = 60
@export var timer: float
@export var date_string: String:
	get:
		return Time.get_date_string_from_unix_time(timer)
@export var time_string: String:
	get:
		return Time.get_time_string_from_unix_time(timer)


func _init() -> void:
	timer = Time.get_unix_time_from_datetime_string("2025-01-01T08:00:00")


func _process(delta: float) -> void:
	timer += delta * time_scale
