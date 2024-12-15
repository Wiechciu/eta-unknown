extends Node

var cargos: Array[Cargo]
var cargos_dict: Dictionary[int, Cargo]
var currencies: Array[Currency]
var currencies_dict: Dictionary[int, Currency]
var currencies_code_dict: Dictionary[String, Currency]
var job_positions: Array[JobPosition]
var job_positions_dict: Dictionary[int, JobPosition]

var countries: Array[Country]
var countries_dict: Dictionary[int, Country]
var countries_code_dict: Dictionary[String, Country]

var locations: Array[Location]
var locations_dict: Dictionary[int, Location]
var locations_code_dict: Dictionary[String, Location]
var airports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_airport)
var seaports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_seaport)

@export var vehicles: Array[Vehicle]
@export var trucks: Array[Truck]
@export var aircrafts: Array[Aircraft]
@export var ships: Array[Ship]

var parties: Array[Party]
var parties_with_employees: Array[Party]:
	get:
		return parties.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var parties_dict: Dictionary[int, Party]
var customers: Array[Party]
var customers_with_employees: Array[Party]:
	get:
		return customers.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var customers_dict: Dictionary[int, Party]
var freight_forwarders: Array[Party]
var freight_forwarders_with_employees: Array[Party]:
	get:
		return freight_forwarders.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var freight_forwarders_dict: Dictionary[int, Party]
var suppliers: Array[Party]
var suppliers_with_employees: Array[Party]:
	get:
		return suppliers.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var suppliers_dict: Dictionary[int, Party]
var carriers: Array[Party]
var carriers_with_employees: Array[Party]:
	get:
		return carriers.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var carriers_dict: Dictionary[int, Party]
var customs_agencies: Array[Party]
var customs_agencies_with_employees: Array[Party]:
	get:
		return customs_agencies.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var customs_agencies_dict: Dictionary[int, Party]
var handling_agents: Array[Party]
var handling_agents_with_employees: Array[Party]:
	get:
		return handling_agents.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var handling_agents_dict: Dictionary[int, Party]
var truckers: Array[Party]
var truckers_with_employees: Array[Party]:
	get:
		return truckers.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var truckers_dict: Dictionary[int, Party]

var people: Array[Person]
var people_dict: Dictionary[int, Person]
var people_with_employer: Array[Person]:
	get:
		return people.filter(func(person: Person) -> bool: return person.employer != null)

var shipments: Array[Shipment]
var shipments_not_owned: Array[Shipment]:
	get:
		return shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_owned)
var shipments_dict: Dictionary[int, Shipment]

var requests_for_quotation: Array[RequestForQuotation]
var requests_for_quotation_not_awarded: Array[RequestForQuotation]:
	get:
		return requests_for_quotation.filter(func(request: RequestForQuotation) -> bool: return not request.is_awarded)
var requests_for_quotation_dict: Dictionary[int, RequestForQuotation]

var quotations: Array[Quotation]
var quotations_dict: Dictionary[int, Quotation]

var humans: Array[Human]
var humans_dict: Dictionary[int, Human]

var cargo_last_id: int = -1
var currency_last_id: int = -1
var job_position_last_id: int = -1
var party_last_id: int = -1
var country_last_id: int = -1
var location_last_id: int = -1
var person_last_id: int = -1
var vehicle_last_id: int = -1

var shipment_last_id: int = -1
var quotation_last_id: int = -1
var request_for_quotation_last_id: int = -1

var human_last_id: int = -1


func get_cargo_id() -> int:
	cargo_last_id += 1
	return cargo_last_id
func get_currency_id() -> int:
	currency_last_id += 1
	return currency_last_id
func get_job_position_id() -> int:
	job_position_last_id += 1
	return job_position_last_id
func get_party_id() -> int:
	party_last_id += 1
	return party_last_id
func get_country_id() -> int:
	country_last_id += 1
	return country_last_id
func get_location_id() -> int:
	location_last_id += 1
	return location_last_id
func get_person_id() -> int:
	person_last_id += 1
	return person_last_id
func get_vehicle_id() -> int:
	vehicle_last_id += 1
	return vehicle_last_id
func get_shipment_id() -> int:
	shipment_last_id += 1
	return shipment_last_id
func get_quotation_id() -> int:
	quotation_last_id += 1
	return quotation_last_id
func get_request_for_quotation_id() -> int:
	request_for_quotation_last_id += 1
	return request_for_quotation_last_id
func get_human_id() -> int:
	human_last_id += 1
	return human_last_id


func to_dict() -> Dictionary:
	var cargos: Array
	for item: Cargo in GlobalRefs.cargos:
		cargos.append(item.to_dict())
	var currencies: Array
	for item: Currency in GlobalRefs.currencies:
		currencies.append(item.to_dict())
	var job_positions: Array
	for item: JobPosition in GlobalRefs.job_positions:
		job_positions.append(item.to_dict())
	var parties: Array
	for item: Party in GlobalRefs.parties:
		parties.append(item.to_dict())
	var countries: Array
	for item: Country in GlobalRefs.countries:
		countries.append(item.to_dict())
	var locations: Array
	for item: Location in GlobalRefs.locations:
		locations.append(item.to_dict())
	var people: Array
	for item: Person in GlobalRefs.people:
		people.append(item.to_dict())
	var shipments: Array
	for item: Shipment in GlobalRefs.shipments:
		shipments.append(item.to_dict())
	var requests_for_quotation: Array
	for item: RequestForQuotation in GlobalRefs.requests_for_quotation:
		requests_for_quotation.append(item.to_dict())
	var quotations: Array
	for item: Quotation in GlobalRefs.quotations:
		quotations.append(item.to_dict())
	var humans: Array
	for human: Human in GlobalRefs.humans:
		humans.append(human.to_dict())
	
	return {
		"cargos": cargos,
		"currencies": currencies,
		"job_positions": job_positions,
		"countries": countries,
		"locations": locations,
		"parties": parties,
		"people": people,
		"shipments": shipments,
		"requests_for_quotation": requests_for_quotation,
		"quotations": quotations,
		"cargo_last_id": cargo_last_id,
		"currency_last_id": currency_last_id,
		"job_position_last_id": job_position_last_id,
		"party_last_id": party_last_id,
		"country_last_id": country_last_id,
		"location_last_id": location_last_id,
		"person_last_id": person_last_id,
		"vehicle_last_id": vehicle_last_id,
		"shipment_last_id": shipment_last_id,
		"quotation_last_id": quotation_last_id,
		"request_for_quotation_last_id": request_for_quotation_last_id,
		"humans": humans,
	}


func from_dict(data: Dictionary) -> void:
	GlobalRefs.cargos.clear()
	GlobalRefs.cargos_dict.clear()
	for data_item: Dictionary in data["cargos"]:
		var item: Cargo = Cargo.from_dict(data_item)
	GlobalRefs.currencies.clear()
	GlobalRefs.currencies_dict.clear()
	GlobalRefs.currencies_code_dict.clear()
	for data_item: Dictionary in data["currencies"]:
		var item: Currency = Currency.from_dict(data_item)
	GlobalRefs.job_positions.clear()
	GlobalRefs.job_positions_dict.clear()
	for data_item: Dictionary in data["job_positions"]:
		var item: JobPosition = JobPosition.from_dict(data_item)
	GlobalRefs.countries.clear()
	GlobalRefs.countries_dict.clear()
	GlobalRefs.countries_code_dict.clear()
	for data_item: Dictionary in data["countries"]:
		var item: Country = Country.from_dict(data_item)
	GlobalRefs.locations.clear()
	GlobalRefs.locations_dict.clear()
	GlobalRefs.locations_code_dict.clear()
	for data_item: Dictionary in data["locations"]:
		var item: Location = Location.from_dict(data_item)
	GlobalRefs.parties.clear()
	GlobalRefs.parties_dict.clear()
	for data_item: Dictionary in data["parties"]:
		var item: Party = Party.from_dict(data_item)
	GlobalRefs.people.clear()
	GlobalRefs.people_dict.clear()
	for data_item: Dictionary in data["people"]:
		var item: Person = Person.from_dict(data_item)
	GlobalRefs.shipments.clear()
	GlobalRefs.shipments_dict.clear()
	for data_item: Dictionary in data["shipments"]:
		var item: Shipment = Shipment.from_dict(data_item)
	GlobalRefs.requests_for_quotation.clear()
	GlobalRefs.requests_for_quotation_dict.clear()
	for data_item: Dictionary in data["requests_for_quotation"]:
		var item: RequestForQuotation = RequestForQuotation.from_dict(data_item)
	GlobalRefs.quotations.clear()
	GlobalRefs.quotations_dict.clear()
	for data_item: Dictionary in data["quotations"]:
		var item: Quotation = Quotation.from_dict(data_item)
	
	for data_item: Dictionary in data["parties"]:
		parties_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	for data_item: Dictionary in data["people"]:
		people_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	for data_item: Dictionary in data["shipments"]:
		shipments_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	for data_item: Dictionary in data["requests_for_quotation"]:
		requests_for_quotation_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	for data_item: Dictionary in data["quotations"]:
		quotations_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	
	for data_item: Dictionary in data["humans"]:
		humans_dict[data_item["id"] as int].from_dict(data_item)
	
	cargo_last_id = data["cargo_last_id"]
	currency_last_id = data["currency_last_id"]
	job_position_last_id = data["job_position_last_id"]
	party_last_id = data["party_last_id"]
	country_last_id = data["country_last_id"]
	location_last_id = data["location_last_id"]
	person_last_id = data["person_last_id"]
	vehicle_last_id = data["vehicle_last_id"]
	shipment_last_id = data["shipment_last_id"]
	quotation_last_id = data["quotation_last_id"]
	request_for_quotation_last_id = data["request_for_quotation_last_id"]
