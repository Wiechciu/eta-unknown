extends Node3D


@export var door_base: Node3D
@export var door_base_collision_shape: CollisionShape3D
var door_opened_rotation: Vector3 = Vector3(0, 100, 0)


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	toggle()


func toggle() -> void:
	var tween: Tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var target_rotation: Vector3
	print(door_base.rotation)
	if door_base.rotation_degrees == door_opened_rotation:
		target_rotation = Vector3.ZERO
	else:
		target_rotation = door_opened_rotation
	tween.tween_property(door_base, "rotation_degrees", target_rotation, 1.0)
	tween.tween_property(door_base_collision_shape, "rotation_degrees", target_rotation, 1.0)
