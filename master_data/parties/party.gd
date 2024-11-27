class_name Party
extends Resource


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
