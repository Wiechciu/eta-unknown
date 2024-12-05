class_name OsDesktop
extends PanelContainer


signal icon_clicked(app: OsAppData)


@export var _apps_container: Control
@export var _app_icon_scene: PackedScene


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	for child: Node in _apps_container.get_children():
		child.queue_free()


func load_icon(app: OsAppData) -> void:
	var icon: OsAppIcon = (_app_icon_scene.instantiate() as OsAppIcon).with_data(app)
	icon.icon_clicked.connect(_on_icon_clicked)
	_apps_container.add_child(icon)


func _on_icon_clicked(app: OsAppData) -> void:
	icon_clicked.emit(app)


func load_app(app: OsApp) -> void:
	add_child(app)
