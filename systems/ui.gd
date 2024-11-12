extends Control


@export var month: Label
@export var week: Label
@export var day: Label
@export var time: Label


func _process(_delta: float) -> void:
	month.text = str(GlobalTimer.month)
	week.text = str(GlobalTimer.week)
	day.text = str(GlobalTimer.day)
	time.text = str(GlobalTimer.hour) + ":" + str(GlobalTimer.minute)
