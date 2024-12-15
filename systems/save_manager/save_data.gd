class_name SaveData
extends Resource


@export var cargos: Array[Cargo]
@export var cargos_dict: Dictionary[String, Cargo]
@export var currencies: Array[Currency]
@export var currencies_dict: Dictionary[String, Currency]
@export var job_positions: Array[JobPosition]
@export var job_positions_dict: Dictionary[String, JobPosition]

@export var parties: Array[Party]
@export var parties_dict: Dictionary[String, Party]
@export var customers: Array[Customer]
@export var customers_dict: Dictionary[String, Customer]
@export var freight_forwarders: Array[FreightForwarder]
@export var freight_forwarders_dict: Dictionary[String, FreightForwarder]
@export var suppliers: Array[Supplier]
@export var suppliers_dict: Dictionary[String, Supplier]
@export var carriers: Array[Carrier]
@export var carriers_dict: Dictionary[String, Carrier]
@export var customs_agencies: Array[CustomsAgency]
@export var customs_agencies_dict: Dictionary[String, CustomsAgency]
@export var handling_agents: Array[HandlingAgent]
@export var handling_agents_dict: Dictionary[String, HandlingAgent]
@export var truckers: Array[Trucker]
@export var truckers_dict: Dictionary[String, Trucker]

@export var countries: Array[Country]
@export var countries_dict: Dictionary[String, Country]
@export var locations: Array[Location]
@export var locations_dict: Dictionary[String, Location]
@export var people: Array[Person]
@export var people_dict: Dictionary[String, Person]

@export var vehicles: Array[Vehicle]
@export var trucks: Array[Truck]
@export var aircrafts: Array[Aircraft]
@export var ships: Array[Ship]

@export var shipments: Array[Shipment]
@export var requests_for_quotation: Array[RequestForQuotation]

@export var cargo_last_id: int = -1
@export var currency_last_id: int = -1
@export var job_position_last_id: int = -1
@export var party_last_id: int = -1
@export var country_last_id: int = -1
@export var location_last_id: int = -1
@export var person_last_id: int = -1
@export var vehicle_last_id: int = -1

@export var shipment_last_id: int = -1
@export var quotation_last_id: int = -1
@export var request_for_quotation_last_id: int = -1

@export var market_rates_dict: Dictionary[String, float]

@export var player_person: Person


func store_data() -> void:
	self.cargos = GlobalRefs.cargos
	self.cargos_dict = GlobalRefs.cargos_dict
	self.currencies = GlobalRefs.currencies
	self.currencies_dict = GlobalRefs.currencies_dict
	self.job_positions = GlobalRefs.job_positions
	self.job_positions_dict = GlobalRefs.job_positions_dict
	
	self.parties = GlobalRefs.parties
	self.parties_dict = GlobalRefs.parties_dict
	self.customers = GlobalRefs.customers
	self.customers_dict = GlobalRefs.customers_dict
	self.freight_forwarders = GlobalRefs.freight_forwarders
	self.freight_forwarders_dict = GlobalRefs.freight_forwarders_dict
	self.suppliers = GlobalRefs.suppliers
	self.suppliers_dict = GlobalRefs.suppliers_dict
	self.customs_agencies = GlobalRefs.customs_agencies
	self.customs_agencies_dict = GlobalRefs.customs_agencies_dict
	self.handling_agents = GlobalRefs.handling_agents
	self.handling_agents_dict = GlobalRefs.handling_agents_dict
	self.truckers = GlobalRefs.truckers
	self.truckers_dict = GlobalRefs.truckers_dict
	self.countries = GlobalRefs.countries
	self.countries_dict = GlobalRefs.countries_dict
	self.locations = GlobalRefs.locations
	self.locations_dict = GlobalRefs.locations_dict
	self.people = GlobalRefs.people
	self.people_dict = GlobalRefs.people_dict
	
	self.vehicles = GlobalRefs.vehicles
	self.trucks = GlobalRefs.trucks
	self.aircrafts = GlobalRefs.aircrafts
	self.ships = GlobalRefs.ships
	self.shipments = GlobalRefs.shipments
	self.requests_for_quotation = GlobalRefs.requests_for_quotation
	self.cargo_last_id = GlobalRefs.cargo_last_id
	self.currency_last_id = GlobalRefs.currency_last_id
	self.job_position_last_id = GlobalRefs.job_position_last_id
	self.party_last_id = GlobalRefs.party_last_id
	self.country_last_id = GlobalRefs.country_last_id
	self.location_last_id = GlobalRefs.location_last_id
	self.person_last_id = GlobalRefs.person_last_id
	self.vehicle_last_id = GlobalRefs.vehicle_last_id
	self.shipment_last_id = GlobalRefs.shipment_last_id
	self.quotation_last_id = GlobalRefs.quotation_last_id
	self.request_for_quotation_last_id = GlobalRefs.request_for_quotation_last_id
	
	self.market_rates_dict = GlobalMarket.market_rates_dict
	
	self.player_person = GameManager.player.person
	
	for party: Party in parties: 
		print(party.employees.size())


func load_data() -> void:
	GlobalRefs.cargos = self.cargos
	GlobalRefs.cargos_dict = self.cargos_dict
	GlobalRefs.currencies = self.currencies
	GlobalRefs.currencies_dict = self.currencies_dict
	GlobalRefs.job_positions = self.job_positions
	GlobalRefs.job_positions_dict = self.job_positions_dict
	
	GlobalRefs.parties = self.parties
	GlobalRefs.parties_dict = self.parties_dict
	GlobalRefs.customers = self.customers
	GlobalRefs.customers_dict = self.customers_dict
	GlobalRefs.freight_forwarders = self.freight_forwarders
	GlobalRefs.freight_forwarders_dict = self.freight_forwarders_dict
	GlobalRefs.suppliers = self.suppliers
	GlobalRefs.suppliers_dict = self.suppliers_dict
	GlobalRefs.customs_agencies = self.customs_agencies
	GlobalRefs.customs_agencies_dict = self.customs_agencies_dict
	GlobalRefs.handling_agents = self.handling_agents
	GlobalRefs.handling_agents_dict = self.handling_agents_dict
	GlobalRefs.truckers = self.truckers
	GlobalRefs.truckers_dict = self.truckers_dict
	GlobalRefs.countries = self.countries
	GlobalRefs.countries_dict = self.countries_dict
	GlobalRefs.locations = self.locations
	GlobalRefs.locations_dict = self.locations_dict
	GlobalRefs.people = self.people
	GlobalRefs.people_dict = self.people_dict
	
	GlobalRefs.vehicles = self.vehicles
	GlobalRefs.trucks = self.trucks
	GlobalRefs.aircrafts = self.aircrafts
	GlobalRefs.ships = self.ships
	GlobalRefs.shipments = self.shipments
	GlobalRefs.requests_for_quotation = self.requests_for_quotation
	GlobalRefs.cargo_last_id = self.cargo_last_id
	GlobalRefs.currency_last_id = self.currency_last_id
	GlobalRefs.job_position_last_id = self.job_position_last_id
	GlobalRefs.party_last_id = self.party_last_id
	GlobalRefs.country_last_id = self.country_last_id
	GlobalRefs.location_last_id = self.location_last_id
	GlobalRefs.person_last_id = self.person_last_id
	GlobalRefs.vehicle_last_id = self.vehicle_last_id
	GlobalRefs.shipment_last_id = self.shipment_last_id
	GlobalRefs.quotation_last_id = self.quotation_last_id
	GlobalRefs.request_for_quotation_last_id = self.request_for_quotation_last_id
	
	GlobalMarket.market_rates_dict = self.market_rates_dict
	
	GameManager.player.person = self.player_person
	
	for party: Party in parties: 
		print(party.employees.size())
