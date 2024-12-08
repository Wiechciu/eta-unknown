class_name WaterCooler
extends StaticBody3D


@export var area: Area3D
@export var collision_shape: CollisionShape3D
var player_in_range: Player


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	register_interactable()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if player_in_range == null:
		return
	
	var distance_to_player: float = global_position.distance_to(player_in_range.global_position)
	@warning_ignore("narrowing_conversion")
	var new_time_scale: int = GlobalTimer.normal_time_scale * maxf(1, 100 * ((collision_shape.shape as CylinderShape3D).radius - distance_to_player))
	GlobalTimer.set_time_scale(new_time_scale)


func _on_body_entered(body: Node3D) -> void:
	player_in_range = body as Player


func _on_body_exited(body: Node3D) -> void:
	if body == player_in_range:
		player_in_range = null
		GlobalTimer.set_time_scale(GlobalTimer.normal_time_scale)


func register_interactable() -> void:
	for child: Node in get_children():
		var interactable: Interactable = child as Interactable
		if interactable != null:
			interactable.interacted.connect(interact)


func interact() -> void:
	GlobalTimer.start_next_day_with_fade()
