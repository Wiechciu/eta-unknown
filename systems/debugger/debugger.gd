class_name Debugger


static func assert_all_properties(node: Node) -> void:
	var property_list := (node.get_script() as Script).get_script_property_list()
	for property in property_list:
		if property.usage == 4102: #4102 is an exported property 
			var error_message := "Missing assignment of a property \"%s\" on node: \"%s\")"
			assert(node.get(property.name) != null, error_message % [property.name, str(node.get_path())])
