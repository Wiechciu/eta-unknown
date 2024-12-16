## @tool ## Causes issues with project visibility
extends Node


signal game_loaded


@export var fade_screen: ColorRect
@export var progress_bar: ProgressBar
@export_category("Debug only")
@export var open_save_location: bool:
	set(value):
		OS.shell_open(ProjectSettings.globalize_path(save_folder))

## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://"
var save_file_name: String = "save.json"
var save_full_path: String:
	get: return save_folder + save_file_name
var fade_duration: float = 0.3


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	fade_screen.hide()


func start_new_game() -> void:
	progress_bar.value = 0.0
	await fade_out()
	GlobalRefs.clear_all()
	GlobalMarket.clear_all()
	await update_progress_bar(randf_range(10.0, 30.0))
	await reload_main_scene()
	await update_progress_bar(randf_range(40.0, 70.0))
	GameManager.json_loader.start()
	GlobalMarket.create_market_rates()
	await update_progress_bar(100.0)
	game_loaded.emit()
	await fade_in()


func save_game() -> void:
	save_game_to_json()


func load_game() -> void:
	progress_bar.value = 0.0
	await fade_out()
	GlobalRefs.clear_all()
	GlobalMarket.clear_all()
	await update_progress_bar(randf_range(10.0, 30.0))
	await reload_main_scene()
	await update_progress_bar(randf_range(40.0, 70.0))
	load_game_from_json()
	await update_progress_bar(100.0)
	game_loaded.emit()
	await fade_in()


func save_game_to_json() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.WRITE)
	
	## TODO Add furniture state, e.g. Computer open
	## TODO Add current pathing state to Employees
	## TODO Add Inventory state
	
	var data: Dictionary
	data["time"] = GlobalTimer.now_float
	data["global_refs"] = GlobalRefs.to_dict()
	data["market_rates"] = GlobalMarket.market_rates_dict
	
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("--- Saved to: %s ---" % save_file_name)
	ActionLogger.create_log("Saved to: %s." % save_file_name)


func load_game_from_json() -> void:
	if not FileAccess.file_exists(save_full_path):
		print("File not found:", save_full_path)
		return
	
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data == null:
		print("Couldn't load:", save_full_path)
	
	GlobalTimer.from_dict(data)
	GlobalRefs.from_dict(data["global_refs"])
	GlobalMarket.from_dict(data["market_rates"])

	print("--- Loaded from: %s ---" % save_file_name)
	ActionLogger.create_log("Loaded from: %s." % save_file_name)


func reload_main_scene() -> void:
	get_tree().change_scene_to_packed(GameManager.main_scene)
	while get_tree().current_scene == null:
		await get_tree().process_frame


func fade_out() -> void:
	fade_screen.show()
	
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: fade_screen.modulate.a = alpha, 0.0, 1.0, fade_duration)
	await tween.finished


func fade_in() -> void:
	fade_screen.show()
	
	var tween: Tween = create_tween()
	tween.tween_method(func(alpha: float) -> void: fade_screen.modulate.a = alpha, 1.0, 0.0, fade_duration)
	await tween.finished
	
	fade_screen.hide()


func update_progress_bar(value: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(progress_bar, "value", value, 0.2)
	await tween.finished
