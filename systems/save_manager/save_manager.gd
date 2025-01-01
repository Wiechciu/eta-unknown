## TODO Add furniture state, e.g. Computer open
## TODO Add current pathing state to Employees
## TODO Add Inventory state

extends Node


class SaveFileMetadata:
	var save_file_name: String
	var game_version: String
	var timestamp: String

	@warning_ignore("shadowed_variable")
	func with_data(save_file_name: String, game_version: String, timestamp: String) -> SaveFileMetadata:
		self.save_file_name = save_file_name
		self.game_version = game_version
		self.timestamp = timestamp
		return self


signal game_loaded
signal game_saved
signal save_deleted


@export var fade_screen: ColorRect
@export var progress_bar: ProgressBar

## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://saves/"
var save_file_extension: String = ".json"
var save_file_extension_no_dot: String:
	get:
		return save_file_extension.replace(".", "")

var autosave: bool
var autosave_interval: int
var current_interval_count: int = 0
var autosave_file_name: String = "autosave"

var saves_metadata_file_name: String = "saves_metadata"
var saves_metadata_file_extension: String = ".cfg"
var saves_metadata_file_full_path: String:
	get:
		return save_folder + saves_metadata_file_name + saves_metadata_file_extension

var fade_duration: float = 0.3
var is_game_loaded: bool = false
var new_save_name: String:
	get: 
		var company_name: String = GlobalDebugger.escape_characters_for_file_name(GameManager.player.person.employer.name, true)
		return "%s_%s" % [company_name, GlobalTimer.get_nice_datetime_filename_string_from_now()]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(handle_autosave)
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
		ActionLogger.create_log(tr("SAVE_FILE_DOESNT_EXIST").format({"file_name":save_file_name}), true)
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
	
	var data: Dictionary
	data["time"] = GlobalTimer.now_float
	data["global_refs"] = GlobalRefs.to_dict()
	data["market_rates"] = GlobalMarket.market_rates_dict
	
	var file: FileAccess = FileAccess.open(save_folder + save_file_name + save_file_extension, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	create_metadata(save_file_name)
	ActionLogger.create_log(tr("SAVED_GAME").format({"file_name":save_file_name}))


func load_game_from_json(save_file_name: String) -> void:
	var file: FileAccess = FileAccess.open(save_folder + save_file_name + save_file_extension, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data == null:
		ActionLogger.create_log(tr("COULDNT_LOAD_SAVE_FILE").format({"file_name":save_file_name}), true)
		return
	
	GlobalTimer.from_dict(data)
	GlobalRefs.from_dict(data["global_refs"])
	GlobalMarket.from_dict(data["market_rates"])

	ActionLogger.create_log(tr("LOADED_SAVE_FILE").format({"file_name":save_file_name}))


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


func delete_save_file(save_file_name: String) -> void:
	if not save_file_exists(save_file_name):
		ActionLogger.create_log(tr("SAVE_FILE_DOESNT_EXIST").format({"file_name":save_file_name}), true)
		return
	
	DirAccess.remove_absolute(save_folder + save_file_name + save_file_extension)
	delete_metadata(save_file_name)
	ActionLogger.create_log(tr("DELETED_SAVE_FILE").format({"file_name":save_file_name}))
	save_deleted.emit()


func is_version_matched(version: String) -> bool:
	var current_version: String = ProjectSettings.get_setting("application/config/version")
	return version == current_version


func handle_autosave() -> void:
	if not autosave:
		return
	
	current_interval_count += 1
	if current_interval_count >= autosave_interval:
		current_interval_count = 0
		save_game_to_json(autosave_file_name)


func create_metadata(save_file_name: String) -> void:
	var game_version: String = ProjectSettings.get_setting("application/config/version")
	var timestamp: String = Time.get_datetime_string_from_system().replace("T", ", ")
	
	var config: ConfigFile = ConfigFile.new()
	config.load(saves_metadata_file_full_path)
	config.set_value(save_file_name, "game_version", game_version)
	config.set_value(save_file_name, "timestamp", timestamp)
	config.save(saves_metadata_file_full_path)


func delete_metadata(save_file_name: String) -> void:
	var config: ConfigFile = ConfigFile.new()
	config.load(saves_metadata_file_full_path)
	config.erase_section(save_file_name)
	config.save(saves_metadata_file_full_path)


func get_save_files_metadata() -> Array[SaveFileMetadata]:
	var array: Array[SaveFileMetadata]
	var config: ConfigFile = ConfigFile.new()
	config.load(saves_metadata_file_full_path)
	for save_file_name: String in config.get_sections():
		var game_version: String = config.get_value(save_file_name, "game_version")
		var timestamp: String = config.get_value(save_file_name, "timestamp")
		var metadata: SaveFileMetadata = SaveFileMetadata.new().with_data(save_file_name, game_version, timestamp)
		array.append(metadata)
	return array
