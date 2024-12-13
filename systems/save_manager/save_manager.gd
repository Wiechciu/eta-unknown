@tool
extends Node


@export_category("Debug only")
@export var open_save_location: bool:
	set(value):
		OS.shell_open(ProjectSettings.globalize_path(save_folder))


## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://"
var save_file_name: String = "save.dat"
var save_full_path: String:
	get: return save_folder + save_file_name


func save_game() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.WRITE)
	for shipment: Shipment in GlobalRefs.shipments:
		file.store_var(shipment, true)
	print("--- Saved to: %s ----" % save_file_name)


func load_game() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.READ)
	GlobalDebugger.start_timer()
	print("--- Loaded from: %s ----" % save_file_name)
	
	var shipment_count: int = 0
	
	while file.get_position() < file.get_length():
		var content: Variant = file.get_var(true)
		
		if content is Shipment:
			shipment_count += 1
			@warning_ignore("unsafe_cast")
			var shipment: Shipment = content as Shipment
			(GlobalRefs.parties[shipment.shipper.id] as Customer).load_saved_shipment_data(shipment)
	
	print("loaded %s shipments | in %s ms" % [shipment_count, GlobalDebugger.get_elapsed_time()])
