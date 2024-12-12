extends Node

var cargos: Array[Cargo]
var cargos_dict: Dictionary[String, Cargo]
var currencies: Array[Currency]
var currencies_dict: Dictionary[String, Currency]
var job_positions: Array[JobPosition]
var job_positions_dict: Dictionary[String, JobPosition]

var parties: Array[Party]
var parties_with_employees: Array[Party]:
	get:
		return parties.filter(func(party: Party) -> bool: return not party.employees.is_empty())
var parties_dict: Dictionary[String, Party]
var customers: Array[Customer]
var customers_with_employees: Array[Customer]:
	get:
		return customers.filter(func(party: Customer) -> bool: return not party.employees.is_empty())
var customers_dict: Dictionary[String, Customer]
var freight_forwarders: Array[FreightForwarder]
var freight_forwarders_with_employees: Array[FreightForwarder]:
	get:
		return freight_forwarders.filter(func(party: FreightForwarder) -> bool: return not party.employees.is_empty())
var freight_forwarders_dict: Dictionary[String, FreightForwarder]
var suppliers: Array[Supplier]
var suppliers_with_employees: Array[Supplier]:
	get:
		return suppliers.filter(func(party: Supplier) -> bool: return not party.employees.is_empty())
var suppliers_dict: Dictionary[String, Supplier]
var carriers: Array[Carrier]
var carriers_with_employees: Array[Carrier]:
	get:
		return carriers.filter(func(party: Carrier) -> bool: return not party.employees.is_empty())
var carriers_dict: Dictionary[String, Carrier]
var customs_agencies: Array[CustomsAgency]
var customs_agencies_with_employees: Array[CustomsAgency]:
	get:
		return customs_agencies.filter(func(party: CustomsAgency) -> bool: return not party.employees.is_empty())
var customs_agencies_dict: Dictionary[String, CustomsAgency]
var handling_agents: Array[HandlingAgent]
var handling_agents_with_employees: Array[HandlingAgent]:
	get:
		return handling_agents.filter(func(party: HandlingAgent) -> bool: return not party.employees.is_empty())
var handling_agents_dict: Dictionary[String, HandlingAgent]
var truckers: Array[Trucker]
var truckers_with_employees: Array[Trucker]:
	get:
		return truckers.filter(func(party: Trucker) -> bool: return not party.employees.is_empty())
var truckers_dict: Dictionary[String, Trucker]

var countries: Array[Country]
var countries_dict: Dictionary[String, Country]

var locations: Array[Location]
var locations_dict: Dictionary[String, Location]
var airports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_airport)
var seaports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_seaport)

var people: Array[Person]
var people_dict: Dictionary[String, Person]
var people_with_employer: Array[Person]:
	get:
		return people.filter(func(person: Person) -> bool: return person.employer != null)

@export var vehicles: Array[Vehicle]
@export var trucks: Array[Truck]
@export var aircrafts: Array[Aircraft]
@export var ships: Array[Ship]

var shipments: Array[Shipment]
var shipments_not_owned: Array[Shipment]:
	get:
		return shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_owned)

var requests_for_quotation: Array[RequestForQuotation]
var requests_for_quotation_not_awarded: Array[RequestForQuotation]:
	get:
		return requests_for_quotation.filter(func(request: RequestForQuotation) -> bool: return not request.is_awarded)

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
