class_name Location
extends Resource


static var all: Array[Location]
static var all_dict: Dictionary[String, Location]
static var airports: Array[Location]:
	get:
		return all.filter(is_location_airport)
static var seaports: Array[Location]:
	get:
		return all.filter(is_location_seaport)


var code: String
var country: Country
var name: String
var print_string: String:
	get:
		return code + ", " + name + ", " + country.code
var is_airport: bool
var is_seaport: bool



static func is_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return location_to_check.country.code == country_to_check.code


static func is_not_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return not is_in_country(location_to_check, country_to_check)


static func is_location_airport(location_to_check: Location) -> bool:
	return location_to_check.is_airport


static func is_location_seaport(location_to_check: Location) -> bool:
	return location_to_check.is_seaport
