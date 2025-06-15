class_name OsAppPanelHeader
extends Control


var os_app: OsApp
var is_moving: bool
@export var icon_rect: TextureRect
@export var title_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	gui_input.connect(_on_gui_input)
	os_app = UtilityTools.get_parent_of_type(self, OsApp) as OsApp
	icon_rect.texture = os_app.os_app_icon
	title_label.text = os_app.os_app_name


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			os_app.move_to_front()
			is_moving = true
		else:
			is_moving = false
	elif event is InputEventMouseMotion and is_moving:
		os_app.global_position = os_app.global_position + (event as InputEventMouseMotion).relative


func _on_close_button_pressed() -> void:
	os_app.close()


func _on_minimize_button_pressed() -> void:
	os_app.minimize()


func _on_maximize_button_pressed() -> void:
	os_app.position = Vector2.ZERO
