@tool
class_name Interactable
extends Node3D


signal interacted(node: Node)


@export var sprite: Sprite3D
@export var label: Label
@export var hover_information: Control


@export var label_text: String:
	set(value):
		label_text = value
		if label != null:
			label.text = value
@export var label_position: Vector3:
	set(value):
		label_position = value
		if sprite != null:
			sprite.position = value


func _ready() -> void:
	if not Engine.is_editor_hint():
		@warning_ignore("unsafe_method_access")
		GlobalDebugger.assert_all_exported_properties(self)
		sprite.modulate.a = 0
		#hover_information.modulate.a = 0


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localization()


func update_localization() -> void:
	if not is_node_ready():
		await ready
	var event_text: String = "[%s]" % (InputMap.action_get_events("interact")[0] as InputEventKey).as_text_physical_keycode()
	label.text = tr(label_text).format({"action":event_text})


func interact(node: Node) -> void:
	interacted.emit(node)


func on_hover_start() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: sprite.modulate.a = alpha, 0.0, 1.0, 0.5)
	#tween.parallel().tween_method(func(alpha: float) -> void: hover_information.modulate.a = alpha, 0.0, 1.0, 0.5)
	
	#var parent: Node3D = get_parent_node_3d()
	#tween.parallel().tween_property(parent, "scale", Vector3.ONE * 1.1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func on_hover_end() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: sprite.modulate.a = alpha, 1.0, 0.0, 0.5)
	#tween.parallel().tween_method(func(alpha: float) -> void: hover_information.modulate.a = alpha, 1.0, 0.0, 0.5)
	
	#var parent: Node3D = get_parent_node_3d()
	#tween.parallel().tween_property(parent, "scale", Vector3.ONE * 1.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
