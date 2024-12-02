class_name TmsLoadingScreen
extends PanelContainer


@export var tms: Tms
@export var _title: Label
@export var _progress_bar: ProgressBar

var loading_time: float = 3
var title_loading_delay: float = 0.2
var title_loading_time: float = 1


func start_loading() -> void:
	_title.visible_ratio = 0
	visible = true
	var tween: Tween = create_tween()
	tween.tween_property(_progress_bar, "value", _progress_bar.max_value, loading_time)
	tween.set_parallel(true)
	tween.tween_property(_title, "visible_ratio", 1, title_loading_time).set_delay(title_loading_delay)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(hide)
