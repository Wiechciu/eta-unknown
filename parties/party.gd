class_name Party
extends Resource

@export var name: String
@export var street_name: String
@export var street_number: String
@export var house_number: String
@export var postal_code: String
@export var city_name: String
@export var country_code: String
var print_string: String:
	get:
		return name \
		 + "\n" + street_name + " " + street_number + "/" + house_number \
		 + "\n" + postal_code + " " + city_name + ", " + country_code
