class_name Player
extends Human


@export var interactable_finder: InteractableFinder
@export var _head: Node3D
@export var _camera: Camera3D
@export var crosshair: TextureRect
@export var _can_move: bool:
	get:
		return _camera.current and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED

var movement_base_speed: float = 150.0
var sprint_multiplier: float = 3.0
var movement_actual_speed: float
var acceleration_time: float = 0.5
var rotation_speed: float = 0.005
var jump_height: float = 5.0
var head_bobbing_tween: Tween
var head_bobbing_loop_duration: float = 0.5
var head_resting_position: Vector3
var head_max_offset: Vector3 = Vector3(0.0, 0.1, 0.0)


func _ready() -> void:
	super._ready()
	
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	
	@warning_ignore("unsafe_property_access")
	GameManager.player = self
	initial_setup()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	crosshair.visible = _can_move


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	apply_gravity(delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	handle_sprint(event)
	handle_rotation(event)
	handle_jump(event)
	handle_interaction(event)


func initial_setup() -> void:
	movement_actual_speed = movement_base_speed
	
	head_resting_position = _head.position
	head_bobbing_tween = create_tween().set_loops()
	head_bobbing_tween.tween_property(_head, "position", head_resting_position + head_max_offset, head_bobbing_loop_duration / 2)
	head_bobbing_tween.tween_property(_head, "position", head_resting_position, head_bobbing_loop_duration / 2)
	head_bobbing_tween.stop()


func handle_movement(delta: float) -> void:
	if not _can_move:
		return
	
	velocity.x = 0
	velocity.z = 0
	
	var movement_vector2: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var movement_vector3: Vector3 = Vector3(movement_vector2.x, 0, movement_vector2.y)
	var direction_local: Vector3 = global_transform.basis * movement_vector3 
	velocity += direction_local * delta * movement_actual_speed
	
	head_bobbing_tween.set_speed_scale(movement_actual_speed / movement_base_speed)
	if not head_bobbing_tween.is_running() and direction_local != Vector3.ZERO and is_on_floor():
		head_bobbing_tween.play()
	elif head_bobbing_tween.is_running() and (direction_local == Vector3.ZERO or not is_on_floor()):
		head_bobbing_tween.stop()
		var tween: Tween = create_tween()
		tween.tween_property(_head, "position", head_resting_position, 0.1)


func handle_sprint(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		var tween: Tween = create_tween()
		tween.tween_method(func(speed: float) -> void: movement_actual_speed = speed, movement_actual_speed, movement_base_speed * sprint_multiplier, acceleration_time)
	
	if event.is_action_released("sprint"):
		var tween: Tween = create_tween()
		tween.tween_method(func(speed: float) -> void: movement_actual_speed = speed, movement_actual_speed, movement_base_speed, acceleration_time)


func handle_rotation(event: InputEvent) -> void:
	if not _can_move:
		return
	
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		rotation.y -= mouse_motion_event.relative.x * rotation_speed
		_head.rotation.x -= mouse_motion_event.relative.y * rotation_speed
		_head.rotation.x = clampf(_head.rotation.x, PI/-2, PI/2)


func handle_jump(event: InputEvent) -> void:
	if not _can_move or not is_on_floor():
		return
	
	if event.is_action_pressed("jump"):
		velocity += Vector3.UP * jump_height


func handle_interaction(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interactable_finder.interact(self)


func apply_gravity(delta: float) -> void:
	if is_on_floor():
		return
	
	var gravity_vector: Vector3 = PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY_VECTOR)
	var gravity_force: float = PhysicsServer3D.area_get_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY)
	velocity += gravity_vector * gravity_force * delta
