class_name OsAppIcon
extends PanelContainer


signal icon_clicked(app: OsAppData)


@export var _label: Label
@export var _icon: TextureRect
var _app: OsAppData


func with_data(app_data: OsAppData) -> OsAppIcon:
	_app = app_data
	_label.text = app_data.name
	_icon.texture = app_data.icon
	return self


func _on_button_pressed() -> void:
	icon_clicked.emit(_app)
