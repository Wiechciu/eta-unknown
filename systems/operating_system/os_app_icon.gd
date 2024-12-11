class_name OsAppIcon
extends PanelContainer


signal icon_clicked(app_data: OsAppData)


@export var label: Label
@export var icon: TextureRect
var app_data: OsAppData


@warning_ignore("shadowed_variable")
func with_data(app_data: OsAppData) -> OsAppIcon:
	self.app_data = app_data
	self.label.text = app_data.name
	self.icon.texture = app_data.icon
	
	return self


func _on_button_pressed() -> void:
	icon_clicked.emit(app_data)
