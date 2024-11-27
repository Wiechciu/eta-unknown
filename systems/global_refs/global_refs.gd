class_name GlobalRefs
extends Node

var cargos: Array[Cargo]
var cargos_dict: Dictionary[String, Cargo]
var currencies: Array[Currency]
var currencies_dict: Dictionary[String, Currency]
var countries: Array[Country]
var countries_dict: Dictionary[String, Country]
var job_positions: Array[JobPosition]
var job_positions_dict: Dictionary[String, JobPosition]
var people: Array[Person]
var people_dict: Dictionary[String, Cargo]

var parties: Array[Party]
var parties_with_employees: Array[Party]:
	get:
		return parties.filter(_has_employees)
var parties_dict: Dictionary[String, Party]
var customers: Array[Customer]
var customers_with_employees: Array[Customer]:
	get:
		return parties.filter(_has_employees)
var customers_dict: Dictionary[String, Customer]
var freight_forwarders: Array[FreightForwarder]
var freight_forwarders_with_employees: Array[FreightForwarder]:
	get:
		return parties.filter(_has_employees)
var freight_forwarders_dict: Dictionary[String, FreightForwarder]
var suppliers: Array[Supplier]
var suppliers_with_employees: Array[Supplier]:
	get:
		return parties.filter(_has_employees)
var suppliers_dict: Dictionary[String, Supplier]
var carriers: Array[Carrier]
var carriers_with_employees: Array[Carrier]:
	get:
		return parties.filter(_has_employees)
var carriers_dict: Dictionary[String, Carrier]
var customs_agencies: Array[CustomsAgency]
var customs_agencies_with_employees: Array[CustomsAgency]:
	get:
		return parties.filter(_has_employees)
var customs_agencies_dict: Dictionary[String, CustomsAgency]
var handling_agents: Array[HandlingAgent]
var handling_agents_with_employees: Array[HandlingAgent]:
	get:
		return parties.filter(_has_employees)
var handling_agents_dict: Dictionary[String, HandlingAgent]
var truckers: Array[Trucker]
var truckers_with_employees: Array[Trucker]:
	get:
		return parties.filter(_has_employees)
var truckers_dict: Dictionary[String, Trucker]

var locations: Array[Location]
var locations_dict: Dictionary[String, Location]
var airports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_airport)
var seaports: Array[Location]:
	get:
		return locations.filter(func(location: Location) -> bool: return location.is_seaport)

var shipments: Array[Shipment]
var shipments_not_owned: Array[Shipment]:
	get:
		return shipments.filter(func(shipment: Shipment) -> bool: return not shipment.is_owned)


func _has_employees(party: Party) -> bool:
	return not party.employees.is_empty()
