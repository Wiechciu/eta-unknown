class_name Party
extends Resource


@export_storage var id: int
@export_storage var name: String
@export_storage var street_name: String
@export_storage var street_number: String
@export_storage var house_number: String
@export_storage var postal_code: String
@export_storage var city_name: String
@export_storage var country: Country
var print_string: String:
	get:
		var house_number_fixed: String = ("/" + house_number) if (house_number != null and house_number != "") else ""
		var postal_code_fixed: String = (postal_code + " ") if (postal_code != null and postal_code != "") else ""
		return name \
		+ "\n" + street_name + " " + street_number + house_number_fixed \
		+ "\n" + postal_code_fixed + city_name \
		+ "\n" + country.code + " " + country.name

var employees: Array[Person]
@export_storage var balance: float


@warning_ignore("shadowed_variable")
func with_data(id: int, name: String, street_name: String, street_number: String, house_number: String, postal_code: String, city_name: String, country: Country) -> Party:
	self.id = id
	self.name = name
	self.street_name = street_name
	self.street_number = street_number
	self.house_number = house_number
	self.postal_code = postal_code
	self.city_name = city_name
	self.country = country
	
	return self


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"name" = name,
		"street_name" = street_name,
		"street_number" = street_number,
		"house_number" = house_number,
		"postal_code" = postal_code,
		"city_name" = city_name,
		"country_id" = country.id if country else "",
	}


static func from_dict(data: Dictionary) -> Party:
	return Party.new().with_data(
		data["id"],
		data["name"],
		data["street_name"],
		data["street_number"],
		data["house_number"],
		data["postal_code"],
		data["city_name"],
		GlobalRefs.countries[data["country_id"]],
	)


static func array_to_dict(data: Array[Party]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Party in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Party]:
	var array: Array[Party]
	for item: Dictionary in data:
		array.append(Party.from_dict(item))
	return array
