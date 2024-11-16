class_name Location
extends Resource


@export var code: String
@export var country_code: String
@export var name: String
@export var print_string: String:
	get:
		return code + ", " + name + ", " + country_code

static var country_code_to_check: String


static func is_in_country(location_to_check: Location) -> bool:
	return location_to_check.country_code == country_code_to_check


static func is_not_in_country(location_to_check: Location) -> bool:
	return location_to_check.country_code != country_code_to_check
