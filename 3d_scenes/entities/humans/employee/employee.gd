class_name Employee
extends Human


@export var animation_player: AnimationPlayer
@export var target_nodes: Array[Node3D]
var move_duration: float = 2.0
var move_pause: float = 2.0


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	walk()


func walk() -> void:
	var tween: Tween = create_tween().set_loops()
	for target_node: Node3D in target_nodes:
		tween.tween_interval(move_pause)
		tween.tween_callback(look_at.bind(target_node.global_position))
		tween.tween_property(self, "global_position", target_node.global_position, move_duration)
