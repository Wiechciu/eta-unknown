class_name OsDesktop
extends PanelContainer


signal app_opened(app: OsApp)
signal app_closed(app: OsApp)


@export var _app_icons_container: Control


func _ready() -> void:
	for child: Node in _app_icons_container.get_children():
		var app: OsAppIcon = child as OsAppIcon
		app.app_opened.connect(_on_app_opened)


func _on_app_opened(app: OsApp) -> void:
	add_child(app)
	app.closed.connect(_on_app_closed)
	app_opened.emit(app)


func _on_app_closed(app: OsApp) -> void:
	app.closed.disconnect(_on_app_closed)
	app_closed.emit(app)
	app.queue_free()
