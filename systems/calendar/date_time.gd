extends Control


@export var date: Label
@export var time: Label


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)


func _process(_delta: float) -> void:
	date.text = str(GlobalTimer.date_string)
	time.text = str(GlobalTimer.time_string).left(-3)
