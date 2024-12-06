class_name OsAppIconTaskbar
extends PanelContainer


signal icon_clicked(app: OsApp)


@export var _label: Label
@export var _icon: TextureRect
var _app_data: OsAppData
var _app: OsApp


func with_data(app_data: OsAppData, app: OsApp) -> OsAppIconTaskbar:
	_app = app
	_app_data = app_data
	_label.text = app_data.name
	_icon.texture = app_data.icon
	return self


func _on_button_pressed() -> void:
	icon_clicked.emit(_app)
