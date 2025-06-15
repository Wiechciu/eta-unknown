class_name ActionEventButton
extends Button


@export var is_primary: bool
var action_name: String
var event: InputEventKey
var is_listening: bool = false
var color_rect: ColorRect


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	self.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func initialize(action_name: String, event: InputEventKey) -> ActionEventButton:
	self.action_name = action_name
	self.event = event
	if event:
		var event_as_text: String = event.as_text_physical_keycode()
		var translation_key: String = "KEY_%s" % event_as_text.to_upper()
		var translation: String = tr(translation_key)
		self.text = translation if translation != translation_key else event_as_text
	
	return self


func _on_button_pressed() -> void:
	block_screen()
	self.text = "PRESS_KEY"
	is_listening = true


@warning_ignore("shadowed_variable")
func _input(event: InputEvent) -> void:
	if not is_listening:
		return
	
	if not event.is_pressed():
		return
	
	if event.is_action_pressed("cancel") or not event is InputEventKey:
		initialize(self.action_name, self.event)
		get_viewport().set_input_as_handled()
		is_listening = false
		unblock_screen()
		return
	
	if event.is_action_type() and event is InputEventKey:
		event = event as InputEventKey
		if self.event:
			InputMap.action_erase_event(self.action_name, self.event)
		InputMap.action_add_event(self.action_name, event)
		initialize(self.action_name, event)
		recreate_secondary_event()
		get_viewport().set_input_as_handled()
		is_listening = false
		unblock_screen()
		return


func recreate_secondary_event() -> void:
	if not is_primary:
		return
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if events.size() > 1:
		InputMap.action_erase_event(self.action_name, events[0])
		InputMap.action_add_event(self.action_name, events[0])


func block_screen() -> void:
	unblock_screen()
	color_rect = ColorRect.new()
	color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	color_rect.color = Color.BLACK
	color_rect.color.a = 0.0
	get_tree().root.add_child(color_rect)
	var tween: Tween = color_rect.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_method(func(value: float) -> void: color_rect.color.a = value, 0.0, 0.5, 0.1)


func unblock_screen() -> void:
	if color_rect:
		color_rect.queue_free()
