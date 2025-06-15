class_name OsTaskbar
extends PanelContainer


signal start_pressed
signal icon_clicked(os_app: OsApp)


@export var _start: OsStart
@export var _app_icons_container: Control
@export var _app_icon_scene: PackedScene


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	_start.pressed.connect(_on_start_button_pressed)
	for child: Node in _app_icons_container.get_children():
		child.queue_free()


func _on_start_button_pressed() -> void:
	start_pressed.emit()


func load_icon(os_app_data: OsAppData, os_app: OsApp) -> void:
	var icon: OsAppIconTaskbar = (_app_icon_scene.instantiate() as OsAppIconTaskbar).initialize(os_app_data, os_app)
	icon.icon_clicked.connect(_on_icon_clicked)
	_app_icons_container.add_child(icon)


func _on_icon_clicked(os_app: OsApp) -> void:
	icon_clicked.emit(os_app)


func remove_icon(os_app: OsApp) -> void:
	for app_icon: OsAppIconTaskbar in _app_icons_container.get_children():
		if app_icon.os_app == os_app:
			app_icon.queue_free()
			return
