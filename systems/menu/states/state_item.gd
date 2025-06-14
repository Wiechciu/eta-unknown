class_name StateItem
extends Control


var tween_duration: float = 1.0
@export var state_value_change_effect_scene: PackedScene

var state_data: StateData
var state_previous_value: float
@export var state_icon_rect: TextureRect
@export var state_name_label: Label
@export var state_value_label: Label
@export var state_progress_bar: ProgressBar


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(state_data: StateData) -> StateItem:
	self.state_data = state_data
	self.state_icon_rect.texture = state_data.state.state_icon if state_data.state.state_icon != null else PlaceholderTexture2D.new()
	self.state_name_label.text = state_data.state.state_name
	
	self.state_value_label.text = "%d" % [state_data.value]
	self.state_progress_bar.value = state_data.value
	self.state_progress_bar.max_value = state_data.state.max_value
	
	return self


func update_value() -> void:
	var change_amount: float = state_data.value - state_previous_value
	if change_amount == 0:
		return
	
	var color: Color
	if state_data.state.positive_effect:
		if state_data.value / state_data.state.max_value > 0.3:
			color = Color.WHITE
		else:
			color = Color.INDIAN_RED
	else:
		if state_data.value / state_data.state.max_value < 0.5:
			color = Color.WHITE
		else:
			color = Color.INDIAN_RED
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(true)
	tween.tween_property(state_value_label, "text", "%d" % [state_data.value], 0.0)
	tween.tween_property(state_progress_bar, "value", state_data.value, tween_duration)
	tween.tween_property(state_progress_bar, "modulate", color, tween_duration)
	
	spawn_effect(change_amount)
	
	state_previous_value = state_data.value


func spawn_effect(change_amount: float) -> void:
	var effect: StateValueChangeEffect = state_value_change_effect_scene.instantiate() as StateValueChangeEffect
	effect.initialize(state_data.state, change_amount)
	state_progress_bar.add_child(effect)


func show_state_name() -> void:
	state_name_label.show()


func hide_state_name() -> void:
	state_name_label.hide()


func get_tooltip_icon() -> Texture2D:
	if state_data == null:
		return null
	
	return state_data.state.state_icon


func get_tooltip_header() -> String:
	if state_data == null:
		return ""
	
	return "%s (%d / %d)" % [state_data.state.state_name, state_data.value, state_data.state.max_value]


func get_tooltip_body() -> String:
	if state_data == null:
		return ""
	
	return state_data.state.state_description
