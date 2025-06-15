extends StaticBody3D


@export var hour_hand: MeshInstance3D
@export var minute_hand: MeshInstance3D
@export var second_hand: MeshInstance3D


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var time_dict: Dictionary = GlobalTimer.time_dictionary
	var hour_value: float = time_dict["hour"]
	var minute_value: float = time_dict["minute"]
	var second_value: float = time_dict["second"]
	
	if hour_hand != null and hour_hand.visible:
		hour_hand.rotation.z = -(hour_value + minute_value / 60.0 + second_value / 60.0 / 60.0) / 12.0  * TAU
	if minute_hand != null and minute_hand.visible:
		minute_hand.rotation.z = -(minute_value + second_value / 60.0) / 60.0 * TAU
	if second_hand != null and minute_hand.visible:
		second_hand.rotation.z = -(second_value) / 60.0 * TAU
