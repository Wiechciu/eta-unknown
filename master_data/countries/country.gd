class_name Country
extends Resource


var id: int
var code: String
var name: String
var locations: Array[Location]


@warning_ignore("shadowed_variable")
func with_data(id: int, code: String, name: String) -> Country:
	self.id = id
	self.code = code
	self.name = name
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.countries.append(self)
	@warning_ignore("unsafe_property_access")
	GlobalRefs.countries_dict[id] = self
	@warning_ignore("unsafe_property_access")
	GlobalRefs.countries_code_dict[code] = self
	
	return self


func to_dict() -> Dictionary:
	return {
		"id": id,
		"code": code,
		"name": name,
	}


static func from_dict(data: Dictionary) -> Country:
	return Country.new().with_data(
		data["id"],
		data["code"],
		data["name"]
	)


static func array_to_dict(data: Array[Country]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Country in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Country]:
	var array: Array[Country]
	for item: Dictionary in data:
		array.append(Country.from_dict(item))
	return array
