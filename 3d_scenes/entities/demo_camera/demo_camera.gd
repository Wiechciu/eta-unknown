extends Node3D


@export var loop_duration: float = 10.0
@export var camera: Camera3D
@export var pivot: Node3D


func _ready() -> void:
	camera.make_current()
	var tween: Tween = create_tween().set_loops().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(amount: float) -> void: camera.position.y = amount, -1.0, 3.0, loop_duration / 2)
	tween.tween_method(func(amount: float) -> void: camera.rotation.x = amount, deg_to_rad(30), deg_to_rad(-30), loop_duration / 2)
	tween.chain().tween_method(func(amount: float) -> void: camera.position.y = amount, 3.0, -1, loop_duration / 2)
	tween.tween_method(func(amount: float) -> void: camera.rotation.x = amount, deg_to_rad(-30), deg_to_rad(30), loop_duration / 2)
	
	var tween2: Tween = create_tween().set_loops().set_parallel()
	tween2.tween_method(func(amount: float) -> void: pivot.rotation.y = amount, 0.0, TAU, loop_duration)
