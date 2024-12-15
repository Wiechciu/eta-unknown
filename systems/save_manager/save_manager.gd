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
	
	var cargos: Array
	for item: Cargo in GlobalRefs.cargos:
		cargos.append(item.to_dict())
	var currencies: Array
	for item: Currency in GlobalRefs.currencies:
		currencies.append(item.to_dict())
	var job_positions: Array
	for item: JobPosition in GlobalRefs.job_positions:
		job_positions.append(item.to_dict())
	var parties: Array
	for item: Party in GlobalRefs.parties:
		parties.append(item.to_dict())
	var countries: Array
	for item: Country in GlobalRefs.countries:
		countries.append(item.to_dict())
	var locations: Array
	for item: Location in GlobalRefs.locations:
		locations.append(item.to_dict())
	var people: Array
	for item: Person in GlobalRefs.people:
		people.append(item.to_dict())
	var shipments: Array
	for item: Shipment in GlobalRefs.shipments:
		shipments.append(item.to_dict())
	var requests_for_quotation: Array
	for item: RequestForQuotation in GlobalRefs.requests_for_quotation:
		requests_for_quotation.append(item.to_dict())
	var quotations: Array
	for item: Quotation in GlobalRefs.quotations:
		quotations.append(item.to_dict())
	
	# Prepare data
	var data: Dictionary = {
		"cargos": cargos,
		"currencies": currencies,
		"job_positions": job_positions,
		"countries": countries,
		"locations": locations,
		"parties": parties,
		"people": people,
		"shipments": shipments,
		"requests_for_quotation": requests_for_quotation,
		"quotations": quotations,
		"player_person_id": GameManager.player.person.id if GameManager.player.person else "",
		"time": GlobalTimer.now_float,
	}
	
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
	
	GlobalRefs.cargos.clear()
	for data_item: Dictionary in data["cargos"]:
		var item: Cargo = Cargo.from_dict(data_item)
		GlobalRefs.cargos.append(item)
	GlobalRefs.currencies.clear()
	for data_item: Dictionary in data["currencies"]:
		var item: Currency = Currency.from_dict(data_item)
		GlobalRefs.currencies.append(item)
	GlobalRefs.job_positions.clear()
	for data_item: Dictionary in data["job_positions"]:
		var item: JobPosition = JobPosition.from_dict(data_item)
		GlobalRefs.job_positions.append(item)
	GlobalRefs.countries.clear()
	for data_item: Dictionary in data["countries"]:
		var item: Country = Country.from_dict(data_item)
		GlobalRefs.countries.append(item)
	GlobalRefs.locations.clear()
	for data_item: Dictionary in data["locations"]:
		var item: Location = Location.from_dict(data_item)
		GlobalRefs.locations.append(item)
	GlobalRefs.parties.clear()
	for data_item: Dictionary in data["parties"]:
		var item: Party = Party.from_dict(data_item)
		GlobalRefs.parties.append(item)
	GlobalRefs.people.clear()
	for data_item: Dictionary in data["people"]:
		var item: Person = Person.from_dict(data_item)
		GlobalRefs.people.append(item)
	GlobalRefs.shipments.clear()
	for data_item: Dictionary in data["shipments"]:
		var item: Shipment = Shipment.from_dict(data_item)
		GlobalRefs.shipments.append(item)
	GlobalRefs.requests_for_quotation.clear()
	for data_item: Dictionary in data["requests_for_quotation"]:
		var item: RequestForQuotation = RequestForQuotation.from_dict(data_item)
		GlobalRefs.requests_for_quotation.append(item)
	GlobalRefs.quotations.clear()
	for data_item: Dictionary in data["quotations"]:
		var item: Quotation = Quotation.from_dict(data_item)
		GlobalRefs.quotations.append(item)
	
	GameManager.player.person = GlobalRefs.people[data["player_person_id"]]
	GlobalTimer.now_float = data["time"]
	
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
