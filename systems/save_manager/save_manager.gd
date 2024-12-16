## @tool ## Causes issues with project visibility
extends Node


signal game_loaded
signal game_saved
signal save_deleted


@export var fade_screen: ColorRect
@export var progress_bar: ProgressBar
@export_category("Debug only")
@export var open_save_location: bool:
	set(value):
		OS.shell_open(ProjectSettings.globalize_path(save_folder))

## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://saves/"
var save_file_extension: String = ".json"
var save_file_extension_no_dot: String:
	get:
		return save_file_extension.replace(".", "")

#var save_file_name: String = "save.json"
#var save_full_path: String:
	#get: return save_folder + save_file_name

var fade_duration: float = 0.3
var is_game_loaded: bool = false
var new_save_name: String:
	get: 
		var company_name: String = GlobalDebugger.escape_characters_for_file_name(GameManager.player.person.employer.name, true)
		return "%s_%s" % [company_name, GlobalTimer.get_nice_datetime_filename_string_from_now()]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	fade_screen.hide()


func start_new_game() -> void:
	is_game_loaded = false
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
	is_game_loaded = true
	game_loaded.emit()
	await fade_in()


func save_game(save_file_name: String) -> void:
	save_game_to_json(save_file_name)
	game_saved.emit()


func load_game(save_file_name: String) -> void:
	if not save_file_exists(save_file_name):
		ActionLogger.create_log("Save file doesn't exist: %s." % save_file_name, true)
		return
	is_game_loaded = false
	progress_bar.value = 0.0
	await fade_out()
	GlobalRefs.clear_all()
	GlobalMarket.clear_all()
	await update_progress_bar(randf_range(10.0, 30.0))
	await reload_main_scene()
	await update_progress_bar(randf_range(40.0, 70.0))
	load_game_from_json(save_file_name)
	await update_progress_bar(100.0)
	is_game_loaded = true
	game_loaded.emit()
	await fade_in()


func save_game_to_json(save_file_name: String) -> void:
	get_or_create_save_folder()
	
	var file: FileAccess = FileAccess.open(save_folder + save_file_name + save_file_extension, FileAccess.WRITE)
	
	## TODO Save file selection
	## TODO Add furniture state, e.g. Computer open
	## TODO Add current pathing state to Employees
	## TODO Add Inventory state
	
	var data: Dictionary
	data["time"] = GlobalTimer.now_float
	data["global_refs"] = GlobalRefs.to_dict()
	data["market_rates"] = GlobalMarket.market_rates_dict
	
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	ActionLogger.create_log("Saved game as: %s." % save_file_name)


func load_game_from_json(save_file_name: String) -> void:
	var file: FileAccess = FileAccess.open(save_folder + save_file_name + save_file_extension, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data == null:
		ActionLogger.create_log("Couldn't load save file: %s." % save_folder + save_file_name, true)
		return
	
	GlobalTimer.from_dict(data)
	GlobalRefs.from_dict(data["global_refs"])
	GlobalMarket.from_dict(data["market_rates"])

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


func save_file_exists(save_file_name: String) -> bool:
	if FileAccess.file_exists(save_folder + save_file_name + save_file_extension):
		return true
	return false


func get_or_create_save_folder() -> DirAccess:
	var dir_exists: bool = DirAccess.dir_exists_absolute(save_folder)
	if not dir_exists:
		DirAccess.make_dir_absolute(save_folder)
	return DirAccess.open(save_folder)


func get_save_file_names_from_save_folder() -> Array[String]:
	var save_file_names: Array[String]
	var dir: DirAccess = get_or_create_save_folder()
	for file_name: String in dir.get_files():
		if file_name.get_extension() == save_file_extension_no_dot:
			save_file_names.append(file_name.replace(save_file_extension, ""))
	return save_file_names


func delete_save_file(save_file_name: String) -> void:
	if not save_file_exists(save_file_name):
		ActionLogger.create_log("Save file doesn't exist: %s." % save_file_name, true)
		return
	
	DirAccess.remove_absolute(save_folder + save_file_name + save_file_extension)
	ActionLogger.create_log("Save file deleted: %s." % save_file_name)
	save_deleted.emit()
	#OS.move_to_trash(save_folder + save_file_name + save_file_extension)
	
