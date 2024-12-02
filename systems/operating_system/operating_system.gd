class_name OperatingSystem
extends Control


signal closed


@export var _desktop: OsDesktop
@export var _taskbar: OsTaskbar


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	_taskbar.start_pressed.connect(_on_start_button_pressed)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1).from(Color.TRANSPARENT)


func close() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1).from(Color.WHITE)
	tween.tween_callback(queue_free)
	tween.tween_callback(closed.emit)


func _on_start_button_pressed() -> void:
	close()
