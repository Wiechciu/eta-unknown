class_name Employee
extends Human


@export var animation_player: AnimationPlayer
@export var target_nodes: Array[Node3D]
var move_duration: float = 3.0
var rotation_duration: float = 0.5
var move_pause: float = 3.0

var anim_walk: StringName = "walk/Root|Walk"
var anim_idle: StringName = "idle/Root|Idle"


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	walk()


func walk() -> void:
	var index: int = 0
	for node: Node3D in target_nodes:
		var next_node: Node3D = target_nodes[(index + 1) % (target_nodes.size())]
		node.look_at(next_node.global_position)
		index += 1
	
	var last_target_node: Node3D = target_nodes.back() as Node3D
	global_position = target_nodes[-1].global_position
	global_rotation = target_nodes[-2].global_rotation
	
	var tween: Tween = create_tween().set_loops()
	index = 0
	for next_node: Node3D in target_nodes:
		var current_node: Node3D = target_nodes[(index - 1) % (target_nodes.size())]
		var previous_node: Node3D = target_nodes[(index - 2) % (target_nodes.size())]
		
		var difference: float = current_node.global_rotation.y - previous_node.global_rotation.y
		if difference > 0.0:
			tween.tween_method(func(new_rotation: Vector3) -> void: global_rotation = new_rotation, previous_node.global_rotation + Vector3.UP * TAU, current_node.global_rotation, rotation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		else:
			tween.tween_method(func(new_rotation: Vector3) -> void: global_rotation = new_rotation, previous_node.global_rotation, current_node.global_rotation, rotation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_interval(move_pause)

		tween.tween_callback(animation_player.play.bind(anim_walk, 0.1))
		tween.tween_method(func(new_position: Vector3) -> void: global_position = new_position, current_node.global_position, next_node.global_position, move_duration)
		tween.tween_callback(animation_player.play.bind(anim_idle, 0.1))
		index += 1
