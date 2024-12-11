extends Node

## C:\Users\wiech\AppData\Roaming\Godot\app_userdata\Freight Forwarding
var save_location: String = "user://save.dat"


## TODO Doesn't store everything, need to apply Property Usage Storage flag?
## https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-property-usage-storage
func save_game() -> void:
	var file: FileAccess = FileAccess.open(save_location, FileAccess.WRITE)
	#for shipment: Shipment in GlobalRefs.shipments:
		#file.store_var(shipment, true)
	file.store_var(GlobalRefs, true)


func load_game() -> void:
	var file: FileAccess = FileAccess.open(save_location, FileAccess.READ)
	var content: Variant = file.get_var(true)
	add_child(content as Node)
