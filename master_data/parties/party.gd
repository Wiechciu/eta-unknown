class_name Party
extends Resource


var id: int
var name: String
var street_name: String
var street_number: String
var house_number: String
var postal_code: String
var city_name: String
var country: Country
var print_string: String:
	get:
		var house_number_fixed: String = ("/" + house_number) if (house_number != null and house_number != "") else ""
		var postal_code_fixed: String = (postal_code + " ") if (postal_code != null and postal_code != "") else ""
		return name \
		+ "\n" + street_name + " " + street_number + house_number_fixed \
		+ "\n" + postal_code_fixed + city_name \
		+ "\n" + country.code + " " + country.name

var employees: Array[Person]
var balance: float


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
