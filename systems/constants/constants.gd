extends Node


@export_file var locations_json
var locations: Array[Location]

@export_file var parties_json
var parties: Array[Party]


func _ready() -> void:
	load_locations_from_json(locations_json, locations)
	load_parties_from_json(parties_json, parties)



func load_locations_from_json(file_to_load: String, array_to_fill: Array) -> void:
	var loaded_array = load_json_file(file_to_load)
	
	for location in loaded_array:
		var new_location_resource = Location.new()
		new_location_resource.code = str(location.country) + str(location.location) if location.country else ""
		new_location_resource.country_code = str(location.country) if location.country else ""
		new_location_resource.name = str(location.name_wo_diacritics) if location.name_wo_diacritics else ""
		
		locations.append(new_location_resource)
	print("loaded " + str(locations.size()) + " locations")


func load_parties_from_json(file_to_load: String, array_to_fill: Array) -> void:
	var loaded_array = load_json_file(file_to_load)
	
	for party in loaded_array:
		var new_party_resource = Party.new()
		new_party_resource.name = str(party.name) if party.name else ""
		new_party_resource.street_name = str(party.street_name) if party.street_name else ""
		new_party_resource.street_number = str(party.street_number) if party.street_number else ""
		new_party_resource.house_number = str(party.house_number) if party.house_number else ""
		new_party_resource.postal_code = str(party.postal_code) if party.postal_code else ""
		new_party_resource.city_name = str(party.city_name) if party.city_name else ""
		new_party_resource.country_code = str(party.country_code) if party.country_code else ""
		
		parties.append(new_party_resource)
	print("loaded " + str(parties.size()) + " parties")


func load_json_file(file_to_load: String) -> Array:
	var file = FileAccess.open(file_to_load, FileAccess.READ)
	var content = file.get_as_text()
	
	var json = JSON.new()
	if json.parse(content) == OK:
		if typeof(json.data) == TYPE_ARRAY:
			return json.data
		else:
			printerr("unexpected data")
	else:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", file, " at line ", json.get_error_line())
	return Array()
