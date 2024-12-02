class_name OsAppIcon
extends PanelContainer


signal app_opened(app: OsApp)


@export var app_scene: PackedScene


func open() -> void:
	var app: OsApp = app_scene.instantiate() as OsApp
	app_opened.emit(app)


func _on_button_pressed() -> void:
	open()
