@tool
class_name Interactable
extends Node3D


signal interacted(node: Node)


@export var label: Label3D

@export var label_text: String:
	set(value):
		label_text = value
		if label != null:
			label.text = value
@export var label_position: Vector3:
	set(value):
		label_position = value
		if label != null:
			label.position = value


func _ready() -> void:
	if not Engine.is_editor_hint():
		GlobalDebugger.assert_all_exported_properties(self)
		label.modulate.a = 0
		label.outline_modulate.a = 0


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localization()


func update_localization() -> void:
	if not is_node_ready():
		await ready
	var event_text: String = "[%s]" % InputMap.action_get_events("interact")[0].as_text().replace(" (Physical)", "")
	label.text = tr(label_text).format({"action":event_text})


func interact(node: Node) -> void:
	interacted.emit(node)


func show_label() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: label.modulate.a = alpha, 0.0, 1.0, 0.5)
	tween.parallel().tween_method(func(alpha: float) -> void: label.outline_modulate.a = alpha, 0.0, 1.0, 0.5)


func hide_label() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: label.modulate.a = alpha, 1.0, 0.0, 0.5)
	tween.parallel().tween_method(func(alpha: float) -> void: label.outline_modulate.a = alpha, 1.0, 0.0, 0.5)
