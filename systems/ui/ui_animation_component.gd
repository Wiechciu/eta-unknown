class_name UiAnimationComponent
extends Node


enum PivotType {
	DEFAULT,
	CENTER,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

## Set it only if a control different than the parent should be watched for mouse hover events.
@export var control_to_watch: Control

@export_subgroup("Animate scale")
@export var animate_scale: bool = false
@export var scale_animation_pivot_type: PivotType
@export var scale_animation_in_value: Vector2 = Vector2(1.1, 1.1)
var scale_animation_original_value: Vector2

@export_subgroup("Animate move")
@export var animate_move: bool = false
@export var move_offset_animation_in_value: Vector2 = Vector2.RIGHT * 10
var move_offset_animation_original_position: Vector2

@export_subgroup("Animate color")
@export var animate_color: bool = false
@export var color_animation_multiply: bool = true
@export var color_animation_in_value: Color = Color.WHITE
var color_animation_original_value: Color

@export_category("General settings")
@export var animation_in_duration: float = 1.0
@export var animation_out_duration: float = 1.0
@export var animation_in_ease_type: Tween.EaseType
@export var animation_out_ease_type: Tween.EaseType
@export var animation_in_transition_type: Tween.TransitionType
@export var animation_out_transition_type: Tween.TransitionType

var control_to_animate: Control
var animation_out_value: Variant

var tween_in: Tween
var tween_out: Tween

var has_any_animation_type_selected: bool:
	get: return animate_scale or animate_move or animate_color


func _ready() -> void:
	if not has_any_animation_type_selected:
		return
	
	assign_controls()
	
	UtilityTools.assert_all_exported_properties(self)
	
	setup.call_deferred()
	connect_signals()


func assign_controls() -> void:
	control_to_animate = get_parent() as Control
	if control_to_animate == null:
		return
	
	if control_to_watch == null:
		control_to_watch = control_to_animate


func connect_signals() -> void:
	control_to_watch.mouse_entered.connect(animation_in)
	control_to_watch.mouse_exited.connect(animation_out)
	control_to_watch.visibility_changed.connect(_on_visibility_changed.call_deferred)


func setup() -> void:
	if animate_scale:
		match scale_animation_pivot_type:
			PivotType.DEFAULT:
				pass
			PivotType.CENTER:
				control_to_animate.pivot_offset = control_to_animate.size / 2
			PivotType.TOP_LEFT:
				control_to_animate.pivot_offset = Vector2.ZERO
			PivotType.TOP_RIGHT:
				control_to_animate.pivot_offset = Vector2(control_to_animate.size.x, 0.0)
			PivotType.BOTTOM_LEFT:
				control_to_animate.pivot_offset = Vector2(0.0, control_to_animate.size.y)
			PivotType.BOTTOM_RIGHT:
				control_to_animate.pivot_offset = control_to_animate.size
	scale_animation_original_value = control_to_animate.scale
	color_animation_original_value = control_to_animate.modulate
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if not control_to_animate.visible:
		return
	move_offset_animation_original_position = control_to_animate.position
	
	if control_to_watch is Button:
		var button: Button = control_to_watch as Button
		if button.disabled:
			control_to_animate.modulate = Color.TRANSPARENT


func animation_in() -> void:
	if control_to_watch is Button:
		var button: Button = control_to_watch as Button
		if button.disabled:
			return
	
	if tween_out != null and tween_out.is_running():
		tween_out.stop()
	
	tween_in = control_to_animate.create_tween().set_parallel()
	if animate_scale:
		tween_in.tween_property(control_to_animate, "scale", scale_animation_in_value, animation_in_duration).set_ease(animation_in_ease_type).set_trans(animation_in_transition_type)
	if animate_move:
		control_to_animate.position = move_offset_animation_original_position
		tween_in.tween_property(control_to_animate, "position", move_offset_animation_in_value, animation_in_duration).as_relative().set_ease(animation_in_ease_type).set_trans(animation_in_transition_type)
	if animate_color:
		tween_in.tween_property(control_to_animate, "modulate", color_animation_in_value * (color_animation_original_value if color_animation_multiply else Color.WHITE), animation_in_duration).set_ease(animation_in_ease_type).set_trans(animation_in_transition_type)


func animation_out() -> void:
	if control_to_watch is Button:
		var button: Button = control_to_watch as Button
		if button.toggle_mode and button.button_pressed or button.disabled:
			return
	
	if tween_in != null and tween_in.is_running():
		tween_in.stop()
	
	tween_out = control_to_animate.create_tween().set_parallel()
	if animate_scale:
		tween_out.tween_property(control_to_animate, "scale", scale_animation_original_value, animation_out_duration).set_ease(animation_out_ease_type).set_trans(animation_out_transition_type)
	if animate_move:
		tween_out.tween_property(control_to_animate, "position", move_offset_animation_original_position, animation_out_duration).set_ease(animation_out_ease_type).set_trans(animation_out_transition_type)
	if animate_color:
		tween_out.tween_property(control_to_animate, "modulate", color_animation_original_value, animation_out_duration).set_ease(animation_out_ease_type).set_trans(animation_out_transition_type)
