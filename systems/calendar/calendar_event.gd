extends Control


@export var show_tween_duration: float = 0.1
@export var hide_tween_duration: float = 2.0
@export var shown_duration: float = 3.0
@export var calendar_event: Label


func _ready() -> void:
	Debugger.assert_all_properties(self)

	_hide(0)
	GlobalTimer.shift_started.connect(_on_shift_started)
	GlobalTimer.shift_ended.connect(_on_shift_ended)
	GlobalTimer.lunch_started.connect(_on_lunch_started)
	GlobalTimer.lunch_ended.connect(_on_lunch_ended)


func _show(duration: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.WHITE, duration)


func _hide(duration: float) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, duration)


func show_event(event_text: String) -> void:
	calendar_event.text = event_text
	_show(show_tween_duration)
	await get_tree().create_timer(shown_duration).timeout
	_hide(hide_tween_duration)


func _on_shift_started() -> void:
	show_event("Shift started")


func _on_shift_ended() -> void:
	show_event("Shift ended")


func _on_lunch_started() -> void:
	show_event("Lunch started")


func _on_lunch_ended() -> void:
	show_event("Lunch ended")
