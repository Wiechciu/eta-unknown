class_name OsAppLoadingScreen
extends PanelContainer


signal finished_loading

var os_app: OsApp
@export var icon_rect: TextureRect
@export var title_label: Label
@export var progress_bar: ProgressBar

var loading_time: float = 1
var title_loading_delay: float = 0.2
var title_loading_time: float = 0.5

func _ready() -> void:
	os_app = UtilityTools.get_parent_of_type(self, OsApp) as OsApp
	icon_rect.texture = os_app.os_app_icon
	title_label.text = os_app.os_app_name


func start_loading() -> void:
	title_label.visible_ratio = 0
	visible = true
	
	var tween: Tween = create_tween()
	tween.tween_property(title_label, "visible_ratio", 1, title_loading_time).set_delay(title_loading_delay)
	tween.parallel().tween_property(progress_bar, "value", progress_bar.max_value * randf_range(0.1, 0.9), loading_time / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(progress_bar, "value", progress_bar.max_value, loading_time / 2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(finished_loading.emit)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)
	tween.tween_callback(hide)
	await tween.finished
