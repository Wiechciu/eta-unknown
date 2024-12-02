class_name OsCalendar
extends Label


func _process(delta: float) -> void:
	text = GlobalTimer.get_nice_datetime_string_from_now()
