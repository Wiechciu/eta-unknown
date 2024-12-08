extends StaticBody3D


@export var day_label: Label3D
@export var month_label: Label3D
@export var weekday_label: Label3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(update_calendar)



func update_calendar() -> void:
	day_label.text = "%d" % GlobalTimer.current_day
	month_label.text = GlobalTimer.current_month_genitive_string
	weekday_label.text = GlobalTimer.current_weekday_string
