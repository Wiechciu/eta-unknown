class_name Location
extends Resource


var id: int
var code: String
var country: Country
var name: String
var print_string: String:
	get:
		return code + ", " + name + ", " + country.code
var is_airport: bool
var is_seaport: bool


@warning_ignore("shadowed_variable")
func with_data(id: int, code: String, name: String, country: Country) -> Location:
	self.id = id
	self.code = code
	self.name = name
	self.country = country
	
	return self


static func is_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return location_to_check.country.code == country_to_check.code


static func is_not_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return not is_in_country(location_to_check, country_to_check)
