class_name OsDesktop
extends PanelContainer


signal icon_clicked(os_app_data: OsAppData)


@export var _app_icons_container: Control
@export var _apps_container: Control
@export var _app_icon_scene: PackedScene


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	for child: Node in _app_icons_container.get_children():
		child.queue_free()
	for child: Node in _apps_container.get_children():
		child.queue_free()


func load_icon(os_app_data: OsAppData) -> void:
	var icon: OsAppIcon = (_app_icon_scene.instantiate() as OsAppIcon).initialize(os_app_data)
	icon.icon_clicked.connect(_on_icon_clicked)
	_app_icons_container.add_child(icon)


func _on_icon_clicked(os_app_data: OsAppData) -> void:
	icon_clicked.emit(os_app_data)


func load_app(os_app: OsApp) -> void:
	_apps_container.add_child(os_app)
