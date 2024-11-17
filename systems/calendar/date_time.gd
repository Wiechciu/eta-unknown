extends Control


@export var date: Label
@export var time: Label


func _process(_delta: float) -> void:
	date.text = str(GlobalTimer.date_string)
	time.text = str(GlobalTimer.time_string).left(-3)
