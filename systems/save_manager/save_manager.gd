@tool
extends Node


@export_category("Debug")
@export var open_save_location: bool:
	set(value):
		OS.shell_open(ProjectSettings.globalize_path(save_folder))

@export var loaded_objects: Array


## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_folder: String = "user://"
var save_file_name: String = "save.dat"
var save_full_path: String:
	get: return save_folder + save_file_name


## TODO Doesn't store everything, need to apply Property Usage Storage flag?
## https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-property-usage-storage
func save_game() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.WRITE)
	#for shipment: Shipment in GlobalRefs.shipments:
		#file.store_var(shipment, true)
	file.store_var(GlobalRefs.shipments[0], true)
	#file.store_var(GlobalRefs, true)


func load_game() -> void:
	var file: FileAccess = FileAccess.open(save_full_path, FileAccess.READ)
	var content: Variant = file.get_var(true)
	print("Loaded game:")
	print(content)
	loaded_objects.append(content)
	#add_child(content as Node)
