class_name Player
extends Human


@export var interactable_finder: InteractableFinder
@export var head: Node3D
@export var camera: Camera3D
@export var can_move: bool:
	get:
		return camera.current and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not is_immobilized

var inventory: Inventory

var movement_base_speed: float = 150.0
var sprint_multiplier: float = 3.0
var movement_actual_speed: float
var acceleration_time: float = 0.5
var rotation_speed: float = 0.005
var rotation_ease_curve: float = 0.07
var target_rotation: Vector2
var jump_height: float = 5.0
var head_bobbing_tween: Tween
var head_bobbing_loop_duration: float = 0.5
var head_resting_position: Vector3
var head_max_offset: Vector3 = Vector3(0.0, 0.1, 0.0)

var is_immobilized: bool = false


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	super._ready()
	inventory = UtilityTools.get_child_of_type(self, Inventory)
	
	GameManager.player = self
	initial_setup()


func _physics_process(delta: float) -> void:
	handle_rotation(delta)
	handle_movement(delta)
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	handle_sprint(event)
	handle_rotation_input(event)
	handle_jump(event)
	handle_interaction(event)


func initial_setup() -> void:
	movement_actual_speed = movement_base_speed
	setup_head_bobbing_tween()


func setup_head_bobbing_tween() -> void:
	head_resting_position = head.position
	head_bobbing_tween = create_tween().set_loops()
	head_bobbing_tween.tween_property(head, "position", head_resting_position + head_max_offset, head_bobbing_loop_duration / 2)
	head_bobbing_tween.tween_property(head, "position", head_resting_position, head_bobbing_loop_duration / 2)
	head_bobbing_tween.stop()


func handle_movement(delta: float) -> void:
	velocity.x = 0
	velocity.z = 0
	handle_gravity(delta)
	
	if can_move:
		var movement_vector2: Vector2 = Input.get_vector("left", "right", "forward", "backward")
		var movement_vector3: Vector3 = Vector3(movement_vector2.x, 0, movement_vector2.y)
		var direction_local: Vector3 = global_transform.basis * movement_vector3 
		velocity += direction_local * delta * movement_actual_speed
	
	handle_head_bobbing()


func handle_head_bobbing() -> void:
	head_bobbing_tween.set_speed_scale(movement_actual_speed / movement_base_speed)
	if not head_bobbing_tween.is_running() and velocity != Vector3.ZERO and is_on_floor() and can_move:
		head_bobbing_tween.play()
	elif head_bobbing_tween.is_running() and (velocity == Vector3.ZERO or not is_on_floor() or not can_move):
		head_bobbing_tween.stop()
		var tween: Tween = create_tween()
		tween.tween_property(head, "position", head_resting_position, 0.1)


func handle_sprint(event: InputEvent) -> void:
	if event.is_action_pressed("sprint"):
		var tween: Tween = create_tween()
		tween.tween_method(func(speed: float) -> void: movement_actual_speed = speed, movement_actual_speed, movement_base_speed * sprint_multiplier, acceleration_time)
	
	if event.is_action_released("sprint"):
		var tween: Tween = create_tween()
		tween.tween_method(func(speed: float) -> void: movement_actual_speed = speed, movement_actual_speed, movement_base_speed, acceleration_time)


func handle_rotation_input(event: InputEvent) -> void:
	if not can_move:
		return
	
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		target_rotation -= mouse_motion_event.relative * rotation_speed
		target_rotation.y = clampf(target_rotation.y, PI/-2, PI/2)


func handle_rotation(delta: float) -> void:
	rotation.y = lerp_angle(rotation.y, target_rotation.x, ease(delta, rotation_ease_curve))
	head.rotation.x = lerp_angle(head.rotation.x, target_rotation.y, ease(delta, rotation_ease_curve))


func handle_jump(event: InputEvent) -> void:
	if not can_move or not is_on_floor():
		return
	
	if event.is_action_pressed("jump"):
		velocity += Vector3.UP * jump_height


func handle_interaction(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interactable_finder.interact(self)


func handle_gravity(delta: float) -> void:
	if is_on_floor():
		return
	
	velocity += get_gravity() * delta


func immobilize() -> void:
	is_immobilized = true


func unimmobilize() -> void:
	is_immobilized = false
