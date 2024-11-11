class_name Location
extends Resource


@export var code: String
@export var country_code: String
@export var name: String
@export var print_string: String:
	get:
		return code + ", " + name + ", " + country_code
