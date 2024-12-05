class_name OperatingSystem
extends PanelContainer


signal app_opened(app: OsApp)
signal app_closed(app: OsApp)


@export var _desktop: OsDesktop
@export var _taskbar: OsTaskbar
@export var _app_data: Array[OsAppData]

var boot_duration: float = 0.3


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	load_apps()
	start()


func load_apps() -> void:
	for app_data: OsAppData in _app_data:
		_desktop.load_icon(app_data)


func start() -> void:
	_taskbar.start_pressed.connect(_on_start_button_pressed)
	_taskbar.icon_clicked.connect(_on_icon_taskbar_clicked)
	_desktop.icon_clicked.connect(_on_icon_desktop_clicked)
	
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 0.0, 1.0, boot_duration).set_trans(Tween.TRANS_SINE)


func close() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 1.0, 0.0, boot_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	queue_free()


func _on_start_button_pressed() -> void:
	close()


func _on_icon_desktop_clicked(app_data: OsAppData) -> void:
	var app: OsApp = app_data.scene.instantiate() as OsApp
	_desktop.load_app(app)
	app.tree_exited.connect(_on_app_closed.bind(app))
	_taskbar.load_icon(app_data, app)
	app_opened.emit(app)


func _on_icon_taskbar_clicked(app: OsApp) -> void:
	#FIXME
	print("Icon taskbar clicked")


func _on_app_closed(app: OsApp) -> void:
	_taskbar.remove_icon(app)
