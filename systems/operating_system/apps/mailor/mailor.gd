class_name Mailor
extends OsApp


@export var loading_screen: OsAppLoadingScreen


func _ready() -> void:
	super._ready()
	super.start()
	loading_screen.start_loading()
	await loading_screen.finished_loading
