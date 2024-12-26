extends Node3D


@export var door_base: Node3D
@export var door_base_collision_shape: CollisionShape3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = GlobalDebugger.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	toggle()


func toggle() -> void:
	var tween: Tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var target_rotation: Vector3
	if door_base.rotation == Vector3.ZERO:
		target_rotation = Vector3(0, 100, 0)
	else:
		target_rotation = Vector3.ZERO
	tween.tween_property(door_base, "rotation_degrees", target_rotation, 1.0)
	tween.tween_property(door_base_collision_shape, "rotation_degrees", target_rotation, 1.0)
