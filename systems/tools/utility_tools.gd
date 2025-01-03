class_name UtilityTools
extends Node


static var start: int


static func assert_all_exported_properties(node: Node) -> void:
	var script: Script = node.get_script()
	var property_list: Array[Dictionary] = script.get_script_property_list()
	for property: Dictionary in property_list:
		if property.usage == PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE: 
			var error_message: String = "-\"%s\"- property on node: -\"%s\"- is missing assignment"
			var property_name: String = property.name
			var property_value: Variant = node.get(property_name)
			assert(property_value != null, error_message % [property.name, str(node.get_path())])


static func start_timer() -> void:
	start = Time.get_ticks_msec()


static func get_elapsed_time() -> int:
	var end: int = Time.get_ticks_msec()
	return end - start


static func print_elapsed_time() -> void:
	print("Time elapsed: %s ms" % get_elapsed_time())


## Returns all children of given type.
static func get_children_of_type(parent: Node, type: Variant) -> Array:
	var array: Array
	for child: Node in parent.get_children():
		if is_instance_of(child, type):
			array.append(child)
	return array 


## Returns the first child of given type, will ignore the other children.
static func get_child_of_type(parent: Node, type: Variant) -> Node:
	if parent == null:
		return null
	for child: Node in parent.get_children():
		if is_instance_of(child, type):
			return child
	return null 


static func escape_characters_for_file_name(original_string: String, replace_space_with_underscore: bool = false) -> String:
	var result: String = original_string
	var unwanted_chars: Array[String] = [":", "/", "\\", "?", "*", "\"", "|", "%", "<", ">"]
	for c: String in unwanted_chars:
		result = result.replace(c,"_")
	if replace_space_with_underscore:
		result = result.replace(" ", "_")
	return result
