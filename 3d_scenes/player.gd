class_name Player
extends Node3D


@export var interaction_area: InteractionArea

var movement_speed: float = 3
var rotation_speed: float = 3

var movement_direction: Vector3
var rotation_angle: float


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func _process(delta: float) -> void:
	handle_movement(delta)
	handle_rotation(delta)
	handle_interaction()


func handle_movement(delta: float) -> void:
	movement_direction = Vector3.ZERO
	if Input.is_action_pressed("forward", true):
		movement_direction += Vector3.FORWARD
	if Input.is_action_pressed("backward", true):
		movement_direction += Vector3.BACK
	if Input.is_action_pressed("right", true):
		movement_direction += Vector3.RIGHT
	if Input.is_action_pressed("left", true):
		movement_direction += Vector3.LEFT
	translate_object_local(movement_direction * delta * movement_speed)

func handle_rotation(delta: float) -> void:
	rotation_angle = 0
	if Input.is_action_pressed("rotate_right", true):
		rotation_angle -= 1
	if Input.is_action_pressed("rotate_left", true):
		rotation_angle += 1
	rotate_object_local(Vector3.UP, rotation_angle * delta * rotation_speed)


func handle_interaction() -> void:
	if not Input.is_action_just_pressed("interact"):
		return
	if interaction_area.interactable_bodies.is_empty():
		return
	interaction_area.interactable_bodies[0].interact()
