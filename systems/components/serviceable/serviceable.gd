class_name Serviceable
extends Node


@export var texture_progress_bar: TextureProgressBar
var target_modulate_color: Color
var tween_duration: float = 1.0

@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	target_modulate_color = texture_progress_bar.modulate
	texture_progress_bar.value = 0.0
	texture_progress_bar.modulate = Color.TRANSPARENT


func start_service(service_time: float, service_audio_stream: AudioStream) -> void:
	var tween: Tween = create_tween().set_parallel().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(texture_progress_bar, "modulate", target_modulate_color, tween_duration)
	tween.tween_method(func(amount: float) -> void: texture_progress_bar.value = amount, 1.0, 0.0, service_time)
	tween.tween_property(texture_progress_bar, "modulate", Color.TRANSPARENT, tween_duration).set_delay(service_time - tween_duration)
	
	if service_audio_stream != null:
		audio_player.stream = service_audio_stream
		audio_player.play()
