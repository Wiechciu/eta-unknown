class_name OperatingSystem
extends PanelContainer


signal on_closing


@export var _desktop: OsDesktop
@export var _taskbar: OsTaskbar
@export var os_app_datas: Array[OsAppData]
var interfaces: Array[ComputerInterface]

var boot_duration: float = 1
var is_closing: bool


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	load_apps()
	start()


func load_apps() -> void:
	for os_app_data: OsAppData in os_app_datas:
		_desktop.load_icon(os_app_data)


func start() -> void:
	_taskbar.start_pressed.connect(_on_start_button_pressed)
	_taskbar.icon_clicked.connect(_on_icon_taskbar_clicked)
	_desktop.icon_clicked.connect(_on_icon_desktop_clicked)
	
	modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 0.0, 1.0, boot_duration).set_trans(Tween.TRANS_SINE)


func close() -> void:
	is_closing = true
	on_closing.emit()
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: modulate.a = alpha, 1.0, 0.0, boot_duration).set_trans(Tween.TRANS_SINE)
	await tween.finished
	queue_free()


func _on_start_button_pressed() -> void:
	close()


func _on_icon_desktop_clicked(os_app_data: OsAppData) -> void:
	start_app(os_app_data)


func start_app(os_app_data: OsAppData) -> void:
	var os_app: OsApp = os_app_data.scene.instantiate() as OsApp
	os_app.os_app_name = os_app_data.name
	os_app.os_app_icon = os_app_data.icon
	_desktop.load_app(os_app)
	os_app.tree_exited.connect(_on_app_closed.bind(os_app))
	os_app.document_print_ordered.connect(_on_document_print_ordered)
	_taskbar.load_icon(os_app_data, os_app)


func _on_icon_taskbar_clicked(os_app: OsApp) -> void:
	var is_app_at_front: bool = os_app.get_parent().get_children().back() == os_app
	
	if os_app.visible and is_app_at_front:
		await os_app.minimize()
		os_app.get_parent().move_child(os_app, 0)
	elif os_app.visible:
		os_app.move_to_front()
	else:
		os_app.move_to_front()
		await os_app.maximize()

func _on_app_closed(app: OsApp) -> void:
	_taskbar.remove_icon(app)


func _on_document_print_ordered(document: Document, print_type: Document.PrintType) -> void:
	for interface: ComputerInterface in interfaces:
		var printer: Printer = interface as Printer
		if printer != null and printer.print_type == print_type:
			printer.add_document_to_queue(document)
			return
	print("No relevant printer connected")
