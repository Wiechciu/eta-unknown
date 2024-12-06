class_name WaterCooler
extends StaticBody3D


@export var area: Area3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		GlobalTimer.set_time_scale(GlobalTimer.fast_time_scale)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		GlobalTimer.set_time_scale(GlobalTimer.normal_time_scale)
