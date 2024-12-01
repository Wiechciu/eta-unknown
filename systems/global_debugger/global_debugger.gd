extends Node


var start: int


func assert_all_exported_properties(node: Node) -> void:
	var script: Script = node.get_script()
	var property_list: Array[Dictionary] = script.get_script_property_list()
	for property: Dictionary in property_list:
		if property.usage == 4102: #4102 is an exported property 
			var error_message: String = "Missing assignment of a property \"%s\" on node: \"%s\")"
			var property_name: String = property.name
			var property_value: Variant = node.get(property_name)
			assert(property_value != null, error_message % [property.name, str(node.get_path())])


func start_timer() -> void:
	start = Time.get_ticks_msec()


func get_elapsed_time() -> int:
	var end: int = Time.get_ticks_msec()
	return end - start


func print_elapsed_time() -> void:
	print("Time elapsed: %s ms" % get_elapsed_time())
