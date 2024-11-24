class_name Party
extends Resource


static var all: Array[Party]
static var all_dict: Dictionary[String, Party]
static var all_with_employees: Array[Party]:
	get:
		return all.filter(has_employees)


var name: String
var street_name: String
var street_number: String
var house_number: String
var postal_code: String
var city_name: String
var country: Country
var print_string: String:
	get:
		var house_number_fixed = ("/" + house_number) if (house_number != null and house_number != "") else ""
		var postal_code_fixed = (postal_code + " ") if (postal_code != null and postal_code != "") else ""
		return name \
		+ "\n" + street_name + " " + street_number + house_number_fixed \
		+ "\n" + postal_code_fixed + city_name \
		+ "\n" + country.code + " " + country.name

var employees: Array[Person]
var balance: float


static func has_employees(party_to_check: Party) -> bool:
	return not party_to_check.employees.is_empty()
