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
	GlobalDebugger.assert_all_exported_properties(self)
	
	print("--- starting loading from JSONs ---")
	load_cargo_from_json(cargo_json, GlobalRefs.cargos, GlobalRefs.cargos_dict)
	load_currencies_from_json(currencies_json, GlobalRefs.currencies, GlobalRefs.currencies_dict)
	load_countries_from_json(countries_json, GlobalRefs.countries, GlobalRefs.countries_dict)
	load_locations_from_json(locations_json, GlobalRefs.locations, GlobalRefs.locations_dict)
	load_parties_from_json(parties_json, GlobalRefs.parties, GlobalRefs.parties_dict)
	load_job_positions_from_json(job_positions_json, GlobalRefs.job_positions, GlobalRefs.job_positions_dict)
	load_people_from_json(people_json, GlobalRefs.people, GlobalRefs.people_dict)
	
	print("--- finished loading from JSONs ---\n")
	self.queue_free()


func load_cargo_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		@warning_ignore("unsafe_cast")
		var new_resource: Cargo = Cargo.new().with_data(
			GlobalRefs.cargo_last_id,
			str(item.description) if item.description else "",
			str(item.hs_code) if item.hs_code else "",
			item.unit_value as float if item.unit_value else 0.0,
			item.unit_size as float if item.unit_size else 0.0,
			item.unit_weight as float if item.unit_weight else 0.0
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.description] = new_resource
	
	print("loaded %s cargo | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


func load_currencies_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		@warning_ignore("unsafe_cast")
		var new_resource: Currency = Currency.new().with_data(
			GlobalRefs.currency_last_id,
			str(item.code) if item.code else "",
			str(item.name) if item.name else "",
			item.exchange_rate_to_usd as float if item.exchange_rate_to_usd else 0.0
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
	
	print("loaded %s currencies | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


func load_countries_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Country = Country.new().with_data(
			GlobalRefs.country_last_id,
			str(item.code) if item.code else "",
			str(item.name) if item.name else ""
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
	
	print("loaded %s countries | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


func load_locations_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Location = Location.new().with_data(
			GlobalRefs.location_last_id,
			(str(item.country) + str(item.location)) if item.country else "",
			str(item.name_wo_diacritics) if item.name_wo_diacritics else "",
			GlobalRefs.countries_dict[item.country] if item.country else null
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.code] = new_resource
		
		new_resource.country.locations.append(new_resource)
	
	print("loaded %s locations | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


func load_parties_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		var new_resource: Party
		match str(item.type):
			"carrier":
				new_resource = Carrier.new()
				GlobalRefs.carriers.append(new_resource)
				GlobalRefs.carriers_dict[new_resource.name] = new_resource
			"customer":
				new_resource = Customer.new()
				GlobalRefs.customers.append(new_resource)
				GlobalRefs.customers_dict[new_resource.name] = new_resource
			"customs_agency":
				new_resource = CustomsAgency.new()
				GlobalRefs.customs_agencies.append(new_resource)
				GlobalRefs.customs_agencies_dict[new_resource.name] = new_resource
			"freight_forwarder":
				new_resource = FreightForwarder.new()
				GlobalRefs.freight_forwarders.append(new_resource)
				GlobalRefs.freight_forwarders_dict[new_resource.name] = new_resource
			"handling_agent":
				new_resource = HandlingAgent.new()
				GlobalRefs.handling_agents.append(new_resource)
				GlobalRefs.handling_agents_dict[new_resource.name] = new_resource
			"trucker":
				new_resource = Trucker.new()
				GlobalRefs.truckers.append(new_resource)
				GlobalRefs.truckers_dict[new_resource.name] = new_resource
		
		if new_resource is Supplier:
			GlobalRefs.suppliers.append(new_resource)
			GlobalRefs.suppliers_dict[new_resource.name] = new_resource
			(new_resource as Supplier).reliability_factor = randf_range(0.9, 1.0)
			(new_resource as Supplier).cost_factor = randf_range(0.8, 1.0)
		
		new_resource = new_resource.with_data(
			GlobalRefs.party_last_id,
			str(item.name) if item.name else "",
			str(item.street_name) if item.street_name else "",
			str(item.street_number) if item.street_number else "",
			str(item.house_number) if item.house_number else "",
			str(item.postal_code) if item.postal_code else "",
			str(item.city_name) if item.city_name else "",
			GlobalRefs.countries_dict[item.country_code] if item.country_code else null
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.name] = new_resource
	
	print("loaded %s parties | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])
	print("   loaded " + str(GlobalRefs.carriers.size()) + " carriers")
	print("   loaded " + str(GlobalRefs.customers.size()) + " customers")
	print("   loaded " + str(GlobalRefs.customs_agencies.size()) + " customs agencies")
	print("   loaded " + str(GlobalRefs.freight_forwarders.size()) + " freight forwarders")
	print("   loaded " + str(GlobalRefs.handling_agents.size()) + " handling agents")
	print("   loaded " + str(GlobalRefs.truckers.size()) + " truckers")


func load_job_positions_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		@warning_ignore("unsafe_cast")
		var new_resource: JobPosition = JobPosition.new().with_data(
			GlobalRefs.job_position_last_id,
			str(item.title) if item.title else "",
			item.salary as float if item.salary else 0.0
			)
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.title] = new_resource
	
	print("loaded %s job positions | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


func load_people_from_json(file_to_load: String, array_to_fill: Array, dict_to_fill: Dictionary) -> void:
	GlobalDebugger.start_timer()
	var loaded_array: Array = load_json_file(file_to_load)
	
	for item: Dictionary in loaded_array:
		@warning_ignore("unsafe_cast")
		var new_resource: Person = Person.new().with_data(
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
		
		array_to_fill.append(new_resource)
		dict_to_fill[new_resource.full_name] = new_resource
	
	print("loaded %s people | in %s ms" % [array_to_fill.size(), GlobalDebugger.get_elapsed_time()])


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
