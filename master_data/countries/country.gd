class_name Country
extends Resource


@export var id: int
@export var code: String
@export var name: String
@export var coordinates: Vector2
@export var locations: Array[Location]


@warning_ignore("shadowed_variable")
static func create_new(id: int, code: String, name: String, coordinates: Vector2) -> Country:
	var new_country: Country = Country.new()
	new_country.id = id
	new_country.code = code
	new_country.name = name
	new_country.coordinates = coordinates
	
	GlobalRefs.countries.append(new_country)
	
	return new_country


@warning_ignore("shadowed_variable")
static func get_country_by_code(code: String) -> Country:
	for country: Country in GlobalRefs.countries:
		if country.code == code:
			return country
	
	printerr("Could't find country code: " + code)
	return null


func distance_to(other_country: Country) -> float:
	return coordinates.distance_to(other_country.coordinates)


#func to_dict() -> Dictionary:
	#return {
		#"id": id,
		#"code": code,
		#"name": name,
		#"coordinate_x": coordinates.x,
		#"coordinate_y": coordinates.y,
	#}
#static func from_dict(data: Dictionary) -> Country:
	#return Country.new().with_data(
		#data["id"],
		#data["code"],
		#data["name"],
		#Vector2(data["coordinate_x"] as int, data["coordinate_y"] as int)
	#)
#static func array_to_dict(data: Array[Country]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Country in data:
		#array.append(item.to_dict())
	#return array
#static func array_from_dict(data: Array) -> Array[Country]:
	#var array: Array[Country]
	#for item: Dictionary in data:
		#array.append(Country.from_dict(item))
	#return array
