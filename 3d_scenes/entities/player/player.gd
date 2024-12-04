class_name Player
extends CharacterBody3D


@export var _interaction_area: Area3D
@export var _head: Node3D
@export var _camera: Camera3D
@export var _can_move: bool:
	get:
		return _camera.current and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

var movement_speed: float = 3.0
var sprint_multiplier: float = 3.0
var rotation_speed: float = 0.005
var jump_height: float = 3.0


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	handle_movement(delta)


func _input(event: InputEvent) -> void:
	handle_rotation(event)
	handle_jump(event)
	handle_interaction(event)


func handle_movement(delta: float) -> void:
	if not _can_move:
		return
	
	var movement_vector2: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var movement_vector3: Vector3 = Vector3(movement_vector2.x, 0, movement_vector2.y)
	var is_sprinting: bool = Input.is_action_pressed("sprint")
	translate_object_local(movement_vector3 * delta * movement_speed * (sprint_multiplier if is_sprinting else 1))


func handle_rotation(event: InputEvent) -> void:
	if not _can_move:
		return
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * rotation_speed
		_head.rotation.x -= event.relative.y * rotation_speed
		_head.rotation.x = clampf(_head.rotation.x, PI/-2, PI/2)


func handle_jump(event: InputEvent) -> void:
	if not _can_move:
		return
	
	if event.is_action_pressed("jump"):
		pass
		#TODO fix
		velocity += Vector3.UP * jump_height


func handle_interaction(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for area: Area3D in _interaction_area.get_overlapping_areas():
			if area is Interactable:
				area.interact()
