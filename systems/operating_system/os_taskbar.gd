class_name OsTaskbar
extends PanelContainer


signal start_pressed
signal icon_clicked(app: OsApp)


@export var _start: OsStart
@export var _app_icons_container: Control
@export var _app_icon_scene: PackedScene


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	_start.pressed.connect(_on_start_button_pressed)
	for child: Node in _app_icons_container.get_children():
		child.queue_free()


func _on_start_button_pressed() -> void:
	start_pressed.emit()


func load_icon(app_data: OsAppData, app: OsApp) -> void:
	var icon: OsAppIconTaskbar = (_app_icon_scene.instantiate() as OsAppIconTaskbar).with_data(app_data, app)
	icon.icon_clicked.connect(_on_icon_clicked)
	_app_icons_container.add_child(icon)


func _on_icon_clicked(app: OsApp) -> void:
	icon_clicked.emit(app)


func remove_icon(app: OsApp) -> void:
	for app_icon: OsAppIconTaskbar in _app_icons_container.get_children():
		if app_icon._app == app:
			app_icon.queue_free()
			return
