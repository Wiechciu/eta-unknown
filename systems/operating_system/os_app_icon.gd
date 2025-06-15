class_name OsAppIcon
extends PanelContainer


signal icon_clicked(os_app_data: OsAppData)


@export var label: Label
@export var icon: TextureRect
var os_app_data: OsAppData


@warning_ignore("shadowed_variable")
func initialize(os_app_data: OsAppData) -> OsAppIcon:
	self.os_app_data = os_app_data
	self.label.text = os_app_data.name
	self.icon.texture = os_app_data.icon
	
	return self


func _on_button_pressed() -> void:
	icon_clicked.emit(os_app_data)
