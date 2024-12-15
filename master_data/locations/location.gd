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
	
	country.locations.append(self)
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.locations.append(self)
	@warning_ignore("unsafe_property_access")
	GlobalRefs.locations_dict[id] = self
	@warning_ignore("unsafe_property_access")
	GlobalRefs.locations_code_dict[code] = self

	return self


static func is_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return location_to_check.country.code == country_to_check.code


static func is_not_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return not is_in_country(location_to_check, country_to_check)



func to_dict() -> Dictionary:
	return {
		"id": id,
		"code": code,
		"name": name,
		"country_id": country.id if country else "",
	}


static func from_dict(data: Dictionary) -> Location:
	return Location.new().with_data(
		data["id"],
		data["code"],
		data["name"],
		GlobalRefs.countries_dict[data["country_id"] as int],
	)


static func array_to_dict(data: Array[Location]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Location in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Location]:
	var array: Array[Location]
	for item: Dictionary in data:
		array.append(Location.from_dict(item))
	return array
