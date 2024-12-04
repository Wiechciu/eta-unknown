@tool
class_name Interactable
extends Area3D


signal interacted


@export var label: Label3D
@export var collision_shape: CollisionShape3D

@export var label_position: Vector3:
	set(value):
		label_position = value
		label.position = value
@export var interaction_radius: float:
	set(value):
		interaction_radius = value
		var sphere_shape: SphereShape3D = collision_shape.shape as SphereShape3D
		if sphere_shape != null:
			sphere_shape.radius = value


func _ready() -> void:
	label.modulate.a = 0
	label.outline_modulate.a = 0


func interact() -> void:
	interacted.emit()


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		show_label()


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		hide_label()


func show_label() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: label.modulate.a = alpha, 0.0, 1.0, 0.5)
	tween.parallel().tween_method(func(alpha: float) -> void: label.outline_modulate.a = alpha, 0.0, 1.0, 0.5)


func hide_label() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: label.modulate.a = alpha, 1.0, 0.0, 0.5)
	tween.parallel().tween_method(func(alpha: float) -> void: label.outline_modulate.a = alpha, 1.0, 0.0, 0.5)
