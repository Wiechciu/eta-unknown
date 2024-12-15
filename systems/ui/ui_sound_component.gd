class_name UiSoundComponent
extends Node


## Set it only if a control different than the parent should be watched for mouse hover events.
@export var control_to_watch: Control

@export_subgroup("Hover sound")
@export var play_sound_on_hover: bool = true
@export var hover_audio_stream: AudioStream
@export var hover_min_pitch: float = 0.95
@export var hover_max_pitch: float = 1.05

@export_subgroup("Click sound")
@export var play_sound_on_click: bool = true
@export var click_audio_stream: AudioStream
@export var click_min_pitch: float = 0.95
@export var click_max_pitch: float = 1.05

@export_category("Assigned internally")
@export var hover_audio_player: AudioStreamPlayer
@export var click_audio_player: AudioStreamPlayer


var has_any_sound_type_selected: bool:
	get: return play_hover_sound or play_click_sound


func _ready() -> void:
	if not has_any_sound_type_selected:
		return
	
	assign_controls()
	assign_audio_stream()
	connect_signals()
	
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)


func assign_audio_stream() -> void:
	hover_audio_player.stream = hover_audio_stream
	click_audio_player.stream = click_audio_stream


func assign_controls() -> void:
	if control_to_watch == null:
		control_to_watch = get_parent() as Control


func connect_signals() -> void:
	if play_sound_on_hover:
		control_to_watch.mouse_entered.connect(play_hover_sound)
	if play_sound_on_click and control_to_watch is Button:
		(control_to_watch as Button).pressed.connect(play_click_sound)


func play_hover_sound() -> void:
	hover_audio_player.pitch_scale = randf_range(hover_min_pitch, hover_max_pitch)
	hover_audio_player.play()


func play_click_sound() -> void:
	click_audio_player.pitch_scale = randf_range(click_min_pitch, click_max_pitch)
	click_audio_player.play()
