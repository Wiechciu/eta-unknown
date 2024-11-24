class_name Debugger


static func assert_all_exported_properties(node: Node) -> void:
	var script: Script = node.get_script()
	var property_list := script.get_script_property_list()
	for property in property_list:
		if property.usage == 4102: #4102 is an exported property 
			var error_message := "Missing assignment of a property \"%s\" on node: \"%s\")"
			var property_name: String = property.name
			var property_value = node.get(property_name)
			assert(property_value != null, error_message % [property.name, str(node.get_path())])
