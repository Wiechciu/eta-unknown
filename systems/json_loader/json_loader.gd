extends Node


@export_file var cargo_json: String
@export_file var currencies_json: String
@export_file var countries_json: String
@export_file var locations_json: String
@export_file var parties_json: String
@export_file var job_positions_json: String
@export_file var people_json: String


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
	
	print("--- starting loading from JSONs ---")
	var start: int = Time.get_ticks_msec()
	load_cargo_from_json(cargo_json, Cargo.all, Cargo.all_dict)
	load_currencies_from_json(currencies_json, Currency.all, Currency.all_dict)
	load_countries_from_json(countries_json, Country.all, Country.all_dict)
	load_locations_from_json(locations_json, Location.all, Location.all_dict)
	load_parties_from_json(parties_json, Party.all, Party.all_dict)
	load_job_positions_from_json(job_positions_json, JobPosition.all, JobPosition.all_dict)
	load_people_from_json(people_json, Person.all, Person.all_dict)
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("--- finished loading from JSONs | in " + str(time) + " ms ---\n")


func load_cargo_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Cargo = Cargo.new()
		new_resource.description = str(item.description) if item.description else ""
		new_resource.hs_code = str(item.hs_code) if item.hs_code else ""
		new_resource.unit_value = item.unit_value if item.unit_value else 0.0
		new_resource.unit_size = item.unit_size if item.unit_size else 0.0
		new_resource.unit_weight = item.unit_weight if item.unit_weight else 0.0
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.description] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " cargo | in " + str(time) + " ms")


func load_currencies_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Currency = Currency.new()
		new_resource.code = str(item.code) if item.code else ""
		new_resource.name = str(item.name) if item.name else ""
		new_resource.exchange_rate_to_usd = item.exchange_rate_to_usd if item.exchange_rate_to_usd else 0.0
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " currencies | in " + str(time) + " ms")


func load_countries_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Country = Country.new()
		new_resource.code = str(item.code) if item.code else ""
		new_resource.name = str(item.name) if item.name else ""
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " countries | in " + str(time) + " ms")


func load_locations_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Location = Location.new()
		new_resource.code = (str(item.country) + str(item.location)) if item.country else ""
		new_resource.country = Country.all_dict[item.country] if item.country else null
		new_resource.name = str(item.name_wo_diacritics) if item.name_wo_diacritics else ""
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " locations | in " + str(time) + " ms")


func load_parties_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Party
		match str(item.type):
			"carrier":
				new_resource = Carrier.new()
				Carrier.all_specific.append(new_resource)
				Carrier.all_specific_dict[new_resource.name] = new_resource
			"customer":
				new_resource = Customer.new()
				Customer.all_specific.append(new_resource)
				Customer.all_specific_dict[new_resource.name] = new_resource
			"customs_agency":
				new_resource = CustomsAgency.new()
				CustomsAgency.all_specific.append(new_resource)
				CustomsAgency.all_specific_dict[new_resource.name] = new_resource
			"freight_forwarder":
				new_resource = FreightForwarder.new()
				FreightForwarder.all_specific.append(new_resource)
				FreightForwarder.all_specific_dict[new_resource.name] = new_resource
			"handling_agent":
				new_resource = HandlingAgent.new()
				HandlingAgent.all_specific.append(new_resource)
				HandlingAgent.all_specific_dict[new_resource.name] = new_resource
			"trucker":
				new_resource = Trucker.new()
				Trucker.all_specific.append(new_resource)
				Trucker.all_specific_dict[new_resource.name] = new_resource
		
		if new_resource is Supplier:
			(new_resource as Supplier).reliability_factor = randf_range(0.9, 1.0)
			(new_resource as Supplier).cost_factor = randf_range(0.8, 1.0)
		
		new_resource.name = str(item.name) if item.name else ""
		new_resource.street_name = str(item.street_name) if item.street_name else ""
		new_resource.street_number = str(item.street_number) if item.street_number else ""
		new_resource.house_number = str(item.house_number) if item.house_number else ""
		new_resource.postal_code = str(item.postal_code) if item.postal_code else ""
		new_resource.city_name = str(item.city_name) if item.city_name else ""
		new_resource.country = Country.all_dict[item.country_code] if item.country_code else null
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.name] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " parties | in " + str(time) + " ms")
	print("   loaded " + str(Carrier.all_specific.size()) + " carriers")
	print("   loaded " + str(Customer.all_specific.size()) + " customers")
	print("   loaded " + str(CustomsAgency.all_specific.size()) + " customs agencies")
	print("   loaded " + str(FreightForwarder.all_specific.size()) + " freight forwarders")
	print("   loaded " + str(HandlingAgent.all_specific.size()) + " handling agents")
	print("   loaded " + str(Trucker.all_specific.size()) + " truckers")


func load_job_positions_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: JobPosition = JobPosition.new()
		new_resource.title = str(item.title) if item.title else ""
		new_resource.salary = item.salary if item.salary else 0.0
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.title] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " job positions | in " + str(time) + " ms")


func load_people_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	var start: int = Time.get_ticks_msec()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Person = Person.new()
		new_resource.first_name = str(item.first_name) if item.first_name else ""
		new_resource.last_name = str(item.last_name) if item.last_name else ""
		new_resource.gender = str(item.gender) if item.gender else ""
		new_resource.email = str(item.email) if item.email else ""
		new_resource.phone_number = str(item.phone_number) if item.phone_number else ""
		new_resource.birthdate = str(item.birthdate) if item.birthdate else ""
		new_resource.experience = Person.Experience.get(str(item.experience).to_upper()) if item.experience else Person.Experience.NOVICE
		var employer: Party = Party.all.pick_random()
		new_resource.employer = employer
		employer.employees.append(new_resource)
		new_resource.job_position = JobPosition.all.pick_random()
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.full_name] = new_resource
	
	var end: int = Time.get_ticks_msec()
	var time: int = (end - start)
	print("loaded " + str(array_to_fill.size()) + " people | in " + str(time) + " ms")


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
