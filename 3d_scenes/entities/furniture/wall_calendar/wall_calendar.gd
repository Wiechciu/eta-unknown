extends StaticBody3D


@export var label: Label3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(update_calendar)



func update_calendar() -> void:
	var text: String = "%s.%s" % [GlobalTimer.time_dictionary["day"], GlobalTimer.time_dictionary["month"]]

	label.text = text
