extends Control


@export var message_container: Control
@export var audio_player: AudioStreamPlayer

var max_messages: int = 10
var message_duration: float = 5.0
var fade_out_duration: float = 2.0


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	for child: Node in message_container.get_children():
		child.queue_free()
	change_modulate()


func create_log(message: String, is_error: bool = false) -> void:
	var label: Label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	message_container.add_child(label)
	change_modulate()
	
	if is_error:
		audio_player.pitch_scale = randf_range(0.95, 1.05)
		audio_player.play()
		label.modulate = Color(0.9, 0.6, 0.7)
	
	var tween: Tween = label.create_tween()
	tween.tween_interval(message_duration)
	tween.tween_method(func(alpha: float) -> void: label.modulate.a = alpha, 1.0, 0.0, fade_out_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(label.queue_free)
	tween.tween_callback(change_modulate)
	
	if message_container.get_child_count() > max_messages:
		message_container.get_child(0).queue_free()


func change_modulate() -> void:
	await get_tree().process_frame
	if message_container.get_child_count() == 0:
		modulate.a = 0
	else:
		modulate.a = 1
