class_name JsonLoader
extends Node


@export_file var cargo_json: String
@export_file var currencies_json: String
@export_file var countries_json: String
@export_file var locations_json: String
@export_file var parties_json: String
@export_file var job_positions_json: String
@export_file var people_json: String


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


func start() -> void:
	print("--- starting loading from JSONs ---")
	load_cargo_from_json(cargo_json)
	load_currencies_from_json(currencies_json)
	load_job_positions_from_json(job_positions_json)
	load_countries_from_json(countries_json)
	load_locations_from_json(locations_json)
	load_parties_from_json(parties_json)
	load_people_from_json(people_json)
	print("--- finished loading from JSONs ---\n")


func load_cargo_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		Cargo.new().with_data(
			GlobalRefs.get_cargo_id(),
			str(item.description) if item.description else "",
			str(item.hs_code) if item.hs_code else "",
			item.unit_value as float if item.unit_value else 0.0,
			item.unit_size as float if item.unit_size else 0.0,
			item.unit_weight as float if item.unit_weight else 0.0
			)
	
	print("loaded %s cargo | in %s ms" % [GlobalRefs.cargos.size(), UtilityTools.get_elapsed_time()])


func load_currencies_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		Currency.new().with_data(
			GlobalRefs.get_currency_id(),
			str(item.code) if item.code else "",
			str(item.name) if item.name else "",
			item.exchange_rate_to_usd as float if item.exchange_rate_to_usd else 0.0
			)
	
	print("loaded %s currencies | in %s ms" % [GlobalRefs.currencies.size(), UtilityTools.get_elapsed_time()])


func load_job_positions_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		JobPosition.new().with_data(
			GlobalRefs.get_job_position_id(),
			str(item.title) if item.title else "",
			item.salary as float if item.salary else 0.0
			)
	
	print("loaded %s job positions | in %s ms" % [GlobalRefs.job_positions.size(), UtilityTools.get_elapsed_time()])


func load_countries_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	var coordinate_max_x: int = 15
	var coordinate_x: int = 0
	var coordinate_y: int = 0
	for item: Dictionary in loaded_array:
		Country.new().with_data(
			GlobalRefs.get_country_id(),
			str(item.code) if item.code else "",
			str(item.name) if item.name else "",
			Vector2(coordinate_x, coordinate_y),
			)
		if coordinate_x < coordinate_max_x:
			coordinate_x += 1
		else:
			coordinate_x = 0
			coordinate_y += 1
	
	print("loaded %s countries | in %s ms" % [GlobalRefs.countries.size(), UtilityTools.get_elapsed_time()])


func load_locations_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		Location.new().with_data(
			GlobalRefs.get_location_id(),
			(str(item.country) + str(item.location)) if item.country else "",
			str(item.name_wo_diacritics) if item.name_wo_diacritics else "",
			GlobalRefs.countries_code_dict[item.country] if item.country else null
			)
	
	print("loaded %s locations | in %s ms" % [GlobalRefs.locations.size(), UtilityTools.get_elapsed_time()])


func load_parties_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Party = Party.new().with_data(
			GlobalRefs.get_party_id(),
			Party.Type.get(str(item.type).to_upper()) as Party.Type if item.type else Party.Type.CUSTOMER,
			str(item.name) if item.name else "",
			str(item.street_name) if item.street_name else "",
			str(item.street_number) if item.street_number else "",
			str(item.house_number) if item.house_number else "",
			str(item.postal_code) if item.postal_code else "",
			str(item.city_name) if item.city_name else "",
			GlobalRefs.countries_code_dict[item.country_code] if item.country_code else null,
			[] as Array[Person],
			0.0,
			[] as Array[RequestForQuotation],
			[] as Array[Shipment],
			100000,
			0.0,
			0.0,
			0.0,
			)
		
		if new_resource.is_supplier:
			new_resource.reliability_factor = randf_range(0.9, 1.0)
			new_resource.cost_factor = randf_range(0.8, 1.0)
	
	print("loaded %s parties | in %s ms" % [GlobalRefs.parties.size(), UtilityTools.get_elapsed_time()])
	print("   loaded " + str(GlobalRefs.carriers.size()) + " carriers")
	print("   loaded " + str(GlobalRefs.customers.size()) + " customers")
	print("   loaded " + str(GlobalRefs.customs_agencies.size()) + " customs agencies")
	print("   loaded " + str(GlobalRefs.freight_forwarders.size()) + " freight forwarders")
	print("   loaded " + str(GlobalRefs.handling_agents.size()) + " handling agents")
	print("   loaded " + str(GlobalRefs.truckers.size()) + " truckers")


func load_people_from_json(file_to_load: String) -> void:
	UtilityTools.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Person = Person.new().with_data(
			GlobalRefs.get_person_id(),
			str(item.first_name) if item.first_name else "",
			str(item.last_name) if item.last_name else "",
			str(item.gender) if item.gender else "",
			str(item.email) if item.email else "",
			str(item.phone_number) if item.phone_number else "",
			str(item.birthdate) if item.birthdate else "",
			Person.Experience.get(str(item.experience).to_upper()) as Person.Experience if item.experience else Person.Experience.NOVICE,
			GlobalRefs.parties.pick_random() as Party,
			GlobalRefs.job_positions.pick_random() as JobPosition
			)
		new_resource.employer.employees.append(new_resource)
	
	print("loaded %s people | in %s ms" % [GlobalRefs.people.size(), UtilityTools.get_elapsed_time()])


func load_json_file(file_to_load: String) -> Array:
	var file: FileAccess = FileAccess.open(file_to_load, FileAccess.READ)
	if file == null:
		printerr("Failed to open file: " + file_to_load)
		return Array()
	
	var content: String = file.get_as_text()
	var json: JSON = JSON.new()
	var expected_type: int = TYPE_ARRAY
	if json.parse(content) == OK:
		if typeof(json.data) == expected_type:
			return json.data
		else:
			printerr("Unexpected data in JSON: " + type_string(typeof(content)) + " instead of " + type_string(expected_type))
	else:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", file_to_load, " at line ", json.get_error_line())
	return Array()
