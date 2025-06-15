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
static func create_new(id: int, code: String, name: String, country: Country) -> Location:
	var new_location: Location = Location.new()
	new_location.id = id
	new_location.code = code
	new_location.name = name
	new_location.country = country
	
	country.locations.append(new_location)
	
	GlobalRefs.locations.append(new_location)

	return new_location


@warning_ignore("shadowed_variable")
static func get_location_by_code(code: String) -> Location:
	for location: Location in GlobalRefs.locations:
		if location.code == code:
			return location
	
	printerr("Could't find location code: " + code)
	return null


static func is_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return location_to_check.country.code == country_to_check.code


static func is_not_in_country(location_to_check: Location, country_to_check: Country) -> bool:
	return not is_in_country(location_to_check, country_to_check)



#func to_dict() -> Dictionary:
	#return {
		#"id": id,
		#"code": code,
		#"name": name,
		#"country_id": str(country.id) if country else "",
	#}
#
#
#static func from_dict(data: Dictionary) -> Location:
	#return Location.new().with_data(
		#data.id,
		#data.code,
		#data.name,
		#GlobalRefs.countries[data.country_id as int],
	#)
#
#
#static func array_to_dict(data: Array[Location]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Location in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Location]:
	#var array: Array[Location]
	#for item: Dictionary in data:
		#array.append(Location.from_dict(item))
	#return array
