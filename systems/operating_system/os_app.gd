class_name OsApp
extends Control


signal document_print_ordered(document: Document)


var boot_duration: float = 0.3


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func start() -> void:
	await show_with_fade()


func close() -> void:
	await hide_with_fade()
	queue_free()


func minimize() -> void:
	await hide_with_fade()


func maximize() -> void:
	await show_with_fade()


func hide_with_fade() -> void:
	modulate.a = 1.0
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 1.0, 0.0, boot_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	visible = false


func show_with_fade() -> void:
	visible = true
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 0.0, 1.0, boot_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
