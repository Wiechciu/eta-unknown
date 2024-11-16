class_name Party
extends Resource


enum PartyType {
	Customer,
	Company,
	AirCarrier,
	SeaCarrier,
	Trucker,
}

@export var name: String
@export var street_name: String
@export var street_number: String
@export var house_number: String
@export var postal_code: String
@export var city_name: String
@export var country_code: String
@export var party_type: PartyType
var print_string: String:
	get:
		return name \
		 + "\n" + street_name + " " + street_number + "/" + house_number \
		 + "\n" + postal_code + " " + city_name + ", " + country_code


static func is_in_country(party_to_check: Party, country_code_to_check: String) -> bool:
	return party_to_check.country_code == country_code_to_check


static func is_not_in_country(party_to_check: Party, country_code_to_check: String) -> bool:
	return party_to_check.country_code != country_code_to_check
