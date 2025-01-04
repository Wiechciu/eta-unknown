class_name Interactable
extends Node3D


signal interacted(node: Node)


@export var main_control: Control
@export var label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	main_control.modulate.a = 0


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	#TODO: Optimize to not run every frame
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		main_control.hide()
	else:
		main_control.show()
		var margin: float = 5.0
		main_control.position = get_viewport().get_camera_3d().unproject_position(self.global_position)
		main_control.position.y = max(main_control.position.y, label.size.y / 2 + margin)
		main_control.position.y = min(main_control.position.y, get_viewport().size.y - label.size.y / 2 - margin)


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localization()


func update_localization() -> void:
	if not is_node_ready():
		await ready
	var event_text: String = "[%s]" % (InputMap.action_get_events("interact")[0] as InputEventKey).as_text_physical_keycode()
	label.text = tr("PRESS_TO_INTERACT").format({"action": event_text})


func interact(node: Node) -> void:
	interacted.emit(node)


func on_hover_start() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: main_control.modulate.a = alpha, 0.0, 1.0, 0.5)


func on_hover_end() -> void:
	var tween: Tween = create_tween()
	tween.parallel().tween_method(func(alpha: float) -> void: main_control.modulate.a = alpha, 1.0, 0.0, 0.5)
