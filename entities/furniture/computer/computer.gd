class_name Computer
extends StaticBody3D


@export var subviewport: SubViewport
@export var os_scene: PackedScene
@export var input_area: Area3D
@export var camera: Camera3D
@export var light: SpotLight3D
@export var screen_black: MeshInstance3D
@export var interfaces: Array[ComputerInterface]
@export var audio_player: AudioStreamPlayer3D
@export var start_audio_stream: AudioStream
@export var close_audio_stream: AudioStream

var original_camera_position: Vector3
var original_camera_rotation: Vector3
var old_camera: Camera3D
var is_focused: bool
var is_transitioning: bool

var focusing_time: float = 0.5

var os: OperatingSystem


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	input_area.input_event.connect(_on_mouse_input_event)
	input_area.mouse_entered.connect(_on_mouse_entered_area)
	input_area.mouse_exited.connect(_on_mouse_exited_area)
	
	original_camera_position = camera.position
	original_camera_rotation = camera.rotation
	
	light.light_energy = 0.0
	
	register_interactable()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") and is_focused:
		unfocus_view()
		get_viewport().set_input_as_handled()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	if is_transitioning:
		return
	
	if is_focused:
		unfocus_view()
	else:
		focus_view()


func start_os() -> void:
	if os != null and not os.is_closing:
		return
	
	os = os_scene.instantiate() as OperatingSystem
	os.interfaces = interfaces
	subviewport.add_child(os)
	os.on_closing.connect(_on_os_closing)
	fade_in_lights()
	play_start_sound()


func _on_os_closing() -> void:
	fade_out_lights()
	play_close_sound()
	if is_focused:
		unfocus_view()


func fade_in_lights() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(func(energy: float) -> void: light.light_energy = energy ** 2, 0.0, 1.0, os.boot_duration).set_trans(Tween.TRANS_SINE)


func fade_out_lights() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(func(energy: float) -> void: light.light_energy = energy ** 2, 1.0, 0.0, os.boot_duration).set_trans(Tween.TRANS_SINE)


func play_start_sound() -> void:
	audio_player.stream = start_audio_stream
	audio_player.play()


func play_close_sound() -> void:
	audio_player.stream = close_audio_stream
	audio_player.play()


func focus_view() -> void:
	is_transitioning = true
	is_focused = true
	old_camera = get_viewport().get_camera_3d()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	camera.make_current()
	
	GameManager.player.menu.hide_player_hud()
	
	start_os()
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	tween.tween_property(camera, "global_position", camera.global_position, focusing_time).from(old_camera.global_position)
	tween.tween_property(camera, "global_rotation", camera.global_rotation, focusing_time).from(old_camera.global_rotation)
	await tween.finished
	
	is_transitioning = false


func unfocus_view() -> void:
	is_transitioning = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
	tween.tween_property(camera, "global_rotation", old_camera.global_rotation, focusing_time)
	tween.tween_property(camera, "global_position", old_camera.global_position, focusing_time)
	await tween.finished
	
	GameManager.player.menu.show_player_hud()
	
	old_camera.make_current()
	camera.position = original_camera_position
	camera.rotation = original_camera_rotation
	is_focused = false
	is_transitioning = false



# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside: bool = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos2D: Vector2
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0


func _on_mouse_entered_area() -> void:
	is_mouse_inside = true


func _on_mouse_exited_area() -> void:
	is_mouse_inside = false


func _on_mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int)  -> void:
	# Get mesh size to detect edges and make conversions. This code only support PlaneMesh, QuadMesh and BoxMesh.
	var mesh_size: Vector2
	var mesh: Mesh = screen_black.mesh
	if mesh is BoxMesh:
		mesh_size = Vector2((mesh as BoxMesh).size.x, (mesh as BoxMesh).size.y)
	elif mesh is PlaneMesh:
		mesh_size = (mesh as PlaneMesh).size
	elif mesh is QuadMesh:
		mesh_size = (mesh as QuadMesh).size
	
	# Event position in Area3D in world coordinate space.
	var event_pos3D: Vector3 = event_position

	# Current time in seconds since engine start.
	var now: float = Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: affine_inverse accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D =  screen_black.global_transform.affine_inverse() * event_pos3D

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos2D: Vector2 = Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / mesh_size.x
		event_pos2D.y = event_pos2D.y / mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= subviewport.size.x
		event_pos2D.y *= subviewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	subviewport.push_input(event)
