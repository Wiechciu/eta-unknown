class_name OperatingSystem
extends Control


signal closed


@export var _desktop: OsDesktop
@export var _taskbar: OsTaskbar

var boot_duration: float = 0.3


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	modulate.a = 0.0
	start()


func start() -> void:
	_taskbar.start_pressed.connect(_on_start_button_pressed)
	
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 0.0, 1.0, boot_duration)


func close() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 1.0, 0.0, boot_duration)
	tween.tween_callback(queue_free)
	tween.tween_callback(closed.emit)


func _on_start_button_pressed() -> void:
	close()
