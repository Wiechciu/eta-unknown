extends StaticBody3D


@export var weekday_label: Label3D
@export var date_label: Label3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(update_calendar)



func update_calendar() -> void:
	weekday_label.text = "{weekday}".format({
		"weekday":GlobalTimer.weekday_string,
		})
	date_label.text = "{day}.{month}".format({
		"day":"%02d" % GlobalTimer.time_dictionary["day"],
		"month":"%02d" % GlobalTimer.time_dictionary["month"]
		})
