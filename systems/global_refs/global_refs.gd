extends Node

@export var genders: Array[Gender]
@export var personal_info_data: Array[PersonalInfoData]
@export var states: Array[StateDataNew]
@export var skill_categories: Array[SkillCategory]
@export var skills: Array[SkillData]

@export var cargos: Array[Cargo]
@export var currencies: Array[Currency]
@export var job_positions: Array[JobPosition]

@export var countries: Array[Country]
@export var locations: Array[Location]
var airports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_airport)
var seaports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_seaport)

@export var documents: Array[DocumentData]
@export var charges: Array[ChargeData]
@export var events: Array[EventData]
@export var modes_of_transport: Array[ModeOfTransport]
@export var incoterms: Array[IncotermsData]

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


#func to_dict() -> Dictionary:
	#var cargos_temp_array: Array
	#for item: Cargo in self.cargos:
		#cargos_temp_array.append(item.to_dict())
	#var currencies_temp_array: Array
	#for item: Currency in self.currencies:
		#currencies_temp_array.append(item.to_dict())
	#var job_positions_temp_array: Array
	#for item: JobPosition in self.job_positions:
		#job_positions_temp_array.append(item.to_dict())
	#var parties_temp_array: Array
	#for item: Party in self.parties:
		#parties_temp_array.append(item.to_dict())
	#var countries_temp_array: Array
	#for item: Country in self.countries:
		#countries_temp_array.append(item.to_dict())
	#var locations_temp_array: Array
	#for item: Location in self.locations:
		#locations_temp_array.append(item.to_dict())
	#var people_temp_array: Array
	#for item: Person in self.people:
		#people_temp_array.append(item.to_dict())
	#var shipments_temp_array: Array
	#for item: Shipment in self.shipments:
		#shipments_temp_array.append(item.to_dict())
	#var requests_for_quotation_temp_array: Array
	#for item: RequestForQuotation in self.requests_for_quotation:
		#requests_for_quotation_temp_array.append(item.to_dict())
	#var quotations_temp_array: Array
	#for item: Quotation in self.quotations:
		#quotations_temp_array.append(item.to_dict())
	#var humans_temp_array: Array
	#for human: Human in self.humans:
		#humans_temp_array.append(human.to_dict())
	#
	#return {
		#"cargos": cargos_temp_array,
		#"currencies": currencies_temp_array,
		#"job_positions": job_positions_temp_array,
		#"countries": countries_temp_array,
		#"locations": locations_temp_array,
		#"parties": parties_temp_array,
		#"people": people_temp_array,
		#"shipments": shipments_temp_array,
		#"requests_for_quotation": requests_for_quotation_temp_array,
		#"quotations": quotations_temp_array,
		#"humans": humans_temp_array,
		#"cargo_last_id": cargo_last_id,
		#"currency_last_id": currency_last_id,
		#"job_position_last_id": job_position_last_id,
		#"party_last_id": party_last_id,
		#"country_last_id": country_last_id,
		#"location_last_id": location_last_id,
		#"person_last_id": person_last_id,
		#"vehicle_last_id": vehicle_last_id,
		#"shipment_last_id": shipment_last_id,
		#"quotation_last_id": quotation_last_id,
		#"request_for_quotation_last_id": request_for_quotation_last_id,
		#"human_last_id": human_last_id,
	#}
#
#
#func from_dict(data: Dictionary) -> void:
	#for data_item: Dictionary in data["cargos"]:
		#Cargo.from_dict(data_item)
	#for data_item: Dictionary in data["currencies"]:
		#Currency.from_dict(data_item)
	#for data_item: Dictionary in data["job_positions"]:
		#JobPosition.from_dict(data_item)
	#for data_item: Dictionary in data["countries"]:
		#Country.from_dict(data_item)
	#for data_item: Dictionary in data["locations"]:
		#Location.from_dict(data_item)
	#for data_item: Dictionary in data["parties"]:
		#Party.from_dict(data_item)
	#for data_item: Dictionary in data["people"]:
		#Person.from_dict(data_item)
	#for data_item: Dictionary in data["shipments"]:
		#Shipment.from_dict(data_item)
	#for data_item: Dictionary in data["requests_for_quotation"]:
		#RequestForQuotation.from_dict(data_item)
	#for data_item: Dictionary in data["quotations"]:
		#Quotation.from_dict(data_item)
	#for data_item: Dictionary in data["humans"]:
		#humans_dict[data_item["id"] as int].from_dict(data_item)
	#
	#for data_item: Dictionary in data["parties"]:
		#parties_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	#for data_item: Dictionary in data["people"]:
		#people_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	#for data_item: Dictionary in data["shipments"]:
		#shipments_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	#for data_item: Dictionary in data["requests_for_quotation"]:
		#requests_for_quotation_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	#for data_item: Dictionary in data["quotations"]:
		#quotations_dict[data_item["id"] as int].assign_references_from_dict(data_item)
	#
	#cargo_last_id = data["cargo_last_id"]
	#currency_last_id = data["currency_last_id"]
	#job_position_last_id = data["job_position_last_id"]
	#party_last_id = data["party_last_id"]
	#country_last_id = data["country_last_id"]
	#location_last_id = data["location_last_id"]
	#person_last_id = data["person_last_id"]
	#vehicle_last_id = data["vehicle_last_id"]
	#shipment_last_id = data["shipment_last_id"]
	#quotation_last_id = data["quotation_last_id"]
	#request_for_quotation_last_id = data["request_for_quotation_last_id"]
	#human_last_id = data["human_last_id"]


func clear_all() -> void:
	locations.clear() ## TODO: Should I really save 16k locations to disk?
	
	parties.clear()
	parties_dict.clear()
	customers.clear()
	customers_dict.clear()
	freight_forwarders.clear()
	freight_forwarders_dict.clear()
	suppliers.clear()
	suppliers_dict.clear()
	carriers.clear()
	carriers_dict.clear()
	customs_agencies.clear()
	customs_agencies_dict.clear()
	handling_agents.clear()
	handling_agents_dict.clear()
	truckers.clear()
	truckers_dict.clear()
	
	people.clear()
	people_dict.clear()
	shipments.clear()
	shipments_dict.clear()
	requests_for_quotation.clear()
	requests_for_quotation_dict.clear()
	quotations.clear()
	quotations_dict.clear()
	humans.clear()
	humans_dict.clear()
	
	cargo_last_id = -1
	currency_last_id = -1
	job_position_last_id = -1
	party_last_id = -1
	country_last_id = -1
	location_last_id = -1
	person_last_id = -1
	vehicle_last_id = -1
	shipment_last_id = -1
	quotation_last_id = -1
	request_for_quotation_last_id = -1
	human_last_id = -1
