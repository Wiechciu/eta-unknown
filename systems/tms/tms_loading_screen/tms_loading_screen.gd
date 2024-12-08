class_name TmsLoadingScreen
extends PanelContainer


signal finished_loading

@export var tms: Tms
@export var _title: Label
@export var _progress_bar: ProgressBar

var loading_time: float = 2
var title_loading_delay: float = 0.2
var title_loading_time: float = 1


func start_loading() -> void:
	_title.visible_ratio = 0
	visible = true
	
	var tween: Tween = create_tween()
	tween.tween_property(_title, "visible_ratio", 1, title_loading_time).set_delay(title_loading_delay)
	tween.parallel().tween_property(_progress_bar, "value", _progress_bar.max_value * randf_range(0.1, 0.9), loading_time / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_progress_bar, "value", _progress_bar.max_value, loading_time / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(finished_loading.emit)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(hide)
	await tween.finished
