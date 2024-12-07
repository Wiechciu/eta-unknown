class_name OsCalendar
extends Label


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	text = GlobalTimer.get_nice_datetime_string_from_now()
