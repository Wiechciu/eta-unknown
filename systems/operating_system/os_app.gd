class_name OsApp
extends Control


@warning_ignore("unused_signal")
signal document_print_ordered(document: Document, print_type: Document.PrintType)

var os_app_name: String
var os_app_icon: Texture2D
var boot_duration: float = 0.3


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	start()


func start() -> void:
	await show_with_fade()


func close() -> void:
	await hide_with_fade()
	queue_free()


func minimize() -> void:
	await hide_with_slide()


func maximize() -> void:
	await show_with_slide()


func hide_with_fade() -> void:
	modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 1.0, 0.0, boot_duration)
	await tween.finished
	visible = false


func show_with_fade() -> void:
	visible = true
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 0.0, 1.0, boot_duration)
	await tween.finished


func hide_with_slide() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(0, size.y), boot_duration)
	tween.tween_property(self, "scale", Vector2(0, 0), boot_duration)
	await tween.finished
	visible = false


func show_with_slide() -> void:
	visible = true
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(0, 0), boot_duration)
	tween.tween_property(self, "scale", Vector2(1, 1), boot_duration)
	await tween.finished
