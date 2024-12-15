@tool
extends Node


signal game_loaded


@export_category("Debug only")
@export var open_save_location: bool:
	set(value):
		OS.shell_open(ProjectSettings.globalize_path(save_folder))
#@export var saved_save_data: SaveData
#@export var loaded_save_data: SaveData


## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://"
var save_file_name: String = "save.json"
var save_full_path: String:
	get: return save_folder + save_file_name


func start_new_game() -> void:
	GameManager.json_loader.start()
	GlobalMarket.create_market_rates()
	game_loaded.emit()


func save_game() -> void:
	save_game_to_json()
	#save_game_to_resource()
	#save_game_to_binary()


func load_game() -> void:
	load_game_from_json()
	#load_game_from_resource()
	#load_game_from_binary()
	game_loaded.emit()


func save_game_to_json() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.WRITE)
	
	## TODO: Reload scene, so that all Humans and furniture is reset before loading their state.
	## TODO: Add furniture state, e.g. Computer open
	## TODO: Add current pathing state to Employees
	var data: Dictionary
	data["time"] = GlobalTimer.now_float
	data["global_refs"] = GlobalRefs.to_dict()
	
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
	
	print("--- Loaded from: %s ---" % save_file_name)
	ActionLogger.create_log("Loaded from: %s." % save_file_name)


#func save_game_to_resource() -> void:
	#var save_data: SaveData = SaveData.new()
	#save_data.store_data()
	#saved_save_data = save_data
	#
	#var result: Error = ResourceSaver.save(save_data, save_full_path)
	#if result != OK:
		#print("Encountered a problem while saving.")
		#return
	#
	#print("--- Saved to: %s ---" % save_file_name)
	#ActionLogger.create_log("Saved to: %s." % save_file_name)
#
#
#func load_game_from_resource() -> void:
	#if not ResourceLoader.exists(save_full_path):
		#print("There is no file %s to load." % save_file_name)
		#return
	#
	#var save_data: SaveData = ResourceLoader.load(save_full_path, "SaveData", ResourceLoader.CACHE_MODE_IGNORE_DEEP) as SaveData
	#if save_data == null:
		#print("Loaded file %s structure doesn't match expectations." % save_file_name)
		#return
	#
	#loaded_save_data = save_data
	#save_data.load_data()
	#print("--- Loaded from: %s ---" % save_file_name)
	#ActionLogger.create_log("Loaded from: %s." % save_file_name)
#
#
#func save_game_to_binary() -> void:
	#var file: FileAccess = FileAccess.open(save_full_path, FileAccess.WRITE)
	#for shipment: Shipment in GlobalRefs.shipments:
		#file.store_var(shipment, true)
#
#
#func load_game_from_binary() -> void:
	#var file: FileAccess = FileAccess.open(save_full_path, FileAccess.READ)
	#GlobalDebugger.start_timer()
	#
	#var shipment_count: int = 0
	#
	#while file.get_position() < file.get_length():
		#var content: Variant = file.get_var(true)
		#
		#if content is Shipment:
			#shipment_count += 1
			#@warning_ignore("unsafe_cast")
			#var shipment: Shipment = content as Shipment
			#(GlobalRefs.parties[shipment.shipper.id] as Customer).load_saved_shipment_data(shipment)
	#
	#print("loaded %s shipments | in %s ms" % [shipment_count, GlobalDebugger.get_elapsed_time()])
