class_name Party
extends Resource


signal new_shipment_accepted(shipment: Shipment)
signal shipment_status_changed(shipment: Shipment)
signal shipment_details_changed(shipment: Shipment)
signal shipment_list_updated


enum Type {
	CUSTOMER,
	FREIGHT_FORWARDER,
	CARRIER,
	CUSTOMS_AGENCY,
	HANDLING_AGENT,
	TRUCKER,
}

const SUPPLIER_TYPES: Array[Type] = [
	Type.CARRIER,
	Type.CUSTOMS_AGENCY,
	Type.HANDLING_AGENT,
	Type.TRUCKER,
]

const NAME_PREFIXES: Array[String] = preload("res://master_data/parties/party_name_prefixes.json").data
const NAME_BUZZWORDS: Array[String] = preload("res://master_data/parties/party_name_buzzwords.json").data
const NAME_SUFFIXES: Array[String] = preload("res://master_data/parties/party_name_suffixes.json").data
const STREET_PREFIXES: Array[String] = preload("res://master_data/parties/address_street_prefixes.json").data
const STREET_SUFFIXES: Array[String] = preload("res://master_data/parties/address_street_suffixes.json").data
const CITY_PREFIXES: Array[String]  = preload("res://master_data/parties/address_city_prefixes.json").data
const CITY_SUFFIXES: Array[String]  = preload("res://master_data/parties/address_city_suffixes.json").data
const MAX_ATTEMPTS: int = 1000


var id: int
var type: Type
var type_as_string: String:
	get: return "PARTY_TYPE_" + Type.keys()[type]
var name: String
var street_name: String
var street_number: String
var house_number: String
var postal_code: String
var city_name: String
var country: Country
var print_string: String:
	get:
		var house_number_fixed: String = ("/" + house_number) if (house_number != null and house_number != "") else ""
		var postal_code_fixed: String = (postal_code + " ") if (postal_code != null and postal_code != "") else ""
		return name \
		+ "\n" + street_name + " " + street_number + house_number_fixed \
		+ "\n" + postal_code_fixed + city_name \
		+ "\n" + country.code + " " + country.name

var employees: Array[Person]
var balance: float

var requests_for_quotation: Array[RequestForQuotation]
var shipments: Array[Shipment]

var last_shipment_number: int = 1000000
var total_earnings: float

var is_supplier: bool:
	get: return SUPPLIER_TYPES.has(type)
var reliability_factor: float
var cost_factor: float

var domain: String


static func create_new() -> Party:
	var new_party: Party = Party.new()

	new_party.id = GlobalRefs.get_party_id()
	new_party.type = randi_range(0, Party.Type.size() - 1) as Type ##TODO: fix to make some it more diverse type by implementing probabilities. The same with person genders later with the probabilities
	new_party.name = get_unique_name()
	new_party.street_name = STREET_PREFIXES.pick_random() + STREET_SUFFIXES.pick_random()
	new_party.street_number = str(randi_range(1, 100))
	new_party.house_number = str(randi_range(1, 100))
	new_party.postal_code = str(randi_range(10000, 99999))
	new_party.city_name = CITY_PREFIXES.pick_random() + CITY_SUFFIXES.pick_random()
	new_party.country = GlobalRefs.countries.pick_random()
	new_party.employees = [] as Array[Person]
	new_party.balance = 0.0
	
	new_party.requests_for_quotation = [] as Array[RequestForQuotation]
	new_party.shipments = [] as Array[Shipment]
	
	new_party.last_shipment_number = 100000
	new_party.total_earnings = 0.0
	
	new_party.reliability_factor = 0.0
	new_party.cost_factor = 0.0
	
	new_party.domain = generate_domain_for_company_name(new_party.name)
	
	GlobalRefs.parties.append(new_party)
	GlobalRefs.parties_dict[new_party.id] = new_party
	
	match new_party.type:
		Party.Type.CUSTOMER:
			GlobalRefs.customers.append(new_party)
			GlobalRefs.customers_dict[new_party.id] = new_party
		Party.Type.FREIGHT_FORWARDER:
			GlobalRefs.freight_forwarders.append(new_party)
			GlobalRefs.freight_forwarders_dict[new_party.id] = new_party
		Party.Type.CARRIER:
			GlobalRefs.carriers.append(new_party)
			GlobalRefs.carriers_dict[new_party.id] = new_party
		Party.Type.CUSTOMS_AGENCY:
			GlobalRefs.customs_agencies.append(new_party)
			GlobalRefs.customs_agencies_dict[new_party.id] = new_party
		Party.Type.HANDLING_AGENT:
			GlobalRefs.handling_agents.append(new_party)
			GlobalRefs.handling_agents_dict[new_party.id] = new_party
		Party.Type.TRUCKER:
			GlobalRefs.truckers.append(new_party)
			GlobalRefs.truckers_dict[new_party.id] = new_party
	
	if new_party.is_supplier:
		GlobalRefs.suppliers.append(new_party)
		GlobalRefs.suppliers_dict[new_party.id] = new_party
		new_party.reliability_factor = randf_range(0.9, 1.0)
		new_party.cost_factor = randf_range(0.8, 1.0)	
	
	return new_party


static func get_unique_name() -> String:
	var full_name: String = ""
	var attempt_count: int = 0
	
	while attempt_count < MAX_ATTEMPTS:
		var prefix: String = NAME_PREFIXES.pick_random()
		var buzzword: String = NAME_BUZZWORDS.pick_random()
		var suffix: String = NAME_SUFFIXES.pick_random()
		
		# Avoid repeating elements like "Logistics Logistics Inc"
		if prefix.to_lower() == buzzword.to_lower() or \
			prefix.to_lower() == suffix.to_lower() or \
			buzzword.to_lower() == suffix.to_lower():
			attempt_count += 1
			continue
		
		full_name = "%s %s %s" % [prefix, buzzword, suffix]
		
		var name_is_unique: bool = true
		for party: Party in GlobalRefs.parties:
			if party.name == full_name:
				name_is_unique = false
				break
		
		if name_is_unique:
			return full_name
	
		attempt_count += 1
	
	# Fallback if all else fails
	return "Generic Company %d" % randi()


#@warning_ignore("shadowed_variable")
#func with_data(id: int, type: Type, name: String, street_name: String, street_number: String, house_number: String, postal_code: String, city_name: String, country: Country, employees: Array[Person], balance: float, requests_for_quotation: Array[RequestForQuotation], shipments: Array[Shipment], last_shipment_number: int, total_earnings: float, reliability_factor: float, cost_factor: float) -> Party:
	#self.id = id
	#self.type = type
	#self.name = name
	#self.street_name = street_name
	#self.street_number = street_number
	#self.house_number = house_number
	#self.postal_code = postal_code
	#self.city_name = city_name
	#self.country = country
	#self.employees = employees
	#self.balance = balance
	#
	#self.requests_for_quotation = requests_for_quotation
	#self.shipments = shipments
	#
	#self.last_shipment_number = last_shipment_number
	#self.total_earnings = total_earnings
	#
	#self.reliability_factor = reliability_factor
	#self.cost_factor = cost_factor
	#
	#self.domain = generate_domain_for_company_name(self.name)
	#
	#GlobalRefs.parties.append(self)
	#GlobalRefs.parties_dict[id] = self
	#
	#match self.type:
		#Party.Type.CUSTOMER:
			#GlobalRefs.customers.append(self)
			#GlobalRefs.customers_dict[self.id] = self
		#Party.Type.FREIGHT_FORWARDER:
			#GlobalRefs.freight_forwarders.append(self)
			#GlobalRefs.freight_forwarders_dict[self.id] = self
		#Party.Type.CARRIER:
			#GlobalRefs.carriers.append(self)
			#GlobalRefs.carriers_dict[self.id] = self
		#Party.Type.CUSTOMS_AGENCY:
			#GlobalRefs.customs_agencies.append(self)
			#GlobalRefs.customs_agencies_dict[self.id] = self
		#Party.Type.HANDLING_AGENT:
			#GlobalRefs.handling_agents.append(self)
			#GlobalRefs.handling_agents_dict[self.id] = self
		#Party.Type.TRUCKER:
			#GlobalRefs.truckers.append(self)
			#GlobalRefs.truckers_dict[self.id] = self
	#
	#if self.is_supplier:
		#GlobalRefs.suppliers.append(self)
		#GlobalRefs.suppliers_dict[self.id] = self
#
	#return self


static func generate_domain_for_company_name(company_name: String) -> String:
	var sanitized: String = company_name.to_lower()
	var regex: RegEx = RegEx.new()
	
	# Keep only a-z and 0-9; remove everything else
	regex.compile("[^a-z0-9]")
	sanitized = regex.sub(sanitized, "", true)
	
	return sanitized + ".com"


func accept_shipment(new_shipment: Shipment) -> void:
	shipments.append(new_shipment)
	new_shipment.status_changed.connect(_on_shipment_status_changed)
	new_shipment.details_changed.connect(_on_shipment_details_changed)
	new_shipment_accepted.emit(new_shipment)
	shipment_list_updated.emit()


func _on_shipment_status_changed(shipment: Shipment) -> void:
	shipment_status_changed.emit(shipment)
	shipment_list_updated.emit()


func _on_shipment_details_changed(shipment: Shipment) -> void:
	shipment_details_changed.emit(shipment)
	shipment_list_updated.emit()


func get_next_shipment_number() -> int:
	last_shipment_number += 1
	return last_shipment_number


func create_new_request_for_quotation() -> void:
	var new_request: RequestForQuotation = RequestForQuotation.create_new_with_random_data(self)
	if new_request != null:
		requests_for_quotation.append(new_request)


func create_new_shipment() -> void:
	var new_shipment: Shipment = Shipment.create_new_with_random_data(self, null)
	if new_shipment != null:
		shipments.append(new_shipment)


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"type" = type,
		#"name" = name,
		#"street_name" = street_name,
		#"street_number" = street_number,
		#"house_number" = house_number,
		#"postal_code" = postal_code,
		#"city_name" = city_name,
		#"country_id" = str(country.id) if country else "",
		#"employee_ids" = Person.array_to_dict_id(employees),
		#"balance" = balance,
		#"request_for_quotation_ids" = RequestForQuotation.array_to_dict_id(requests_for_quotation),
		#"shipment_ids" = Shipment.array_to_dict_id(shipments),
		#"last_shipment_number" = last_shipment_number,
		#"total_earnings" = total_earnings,
		#"reliability_factor" = reliability_factor,
		#"cost_factor" = cost_factor,
	#}
#
#
#static func from_dict(data: Dictionary) -> Party:
	#return Party.new().with_data(
		#data["id"],
		#data["type"],
		#data["name"],
		#data["street_name"],
		#data["street_number"],
		#data["house_number"],
		#data["postal_code"],
		#data["city_name"],
		#GlobalRefs.countries[data["country_id"] as int],
		#[] as Array[Person],
		#data["balance"],
		#[] as Array[RequestForQuotation],
		#[] as Array[Shipment],
		#data["last_shipment_number"],
		#data["total_earnings"],
		#data["reliability_factor"],
		#data["cost_factor"],
	#)
#
#
#func assign_references_from_dict(data: Dictionary) -> void:
	#self.employees = Person.array_from_dict_id(data["employee_ids"]) if data["employee_ids"] else ([] as Array[Person])
	#self.requests_for_quotation = RequestForQuotation.array_from_dict_id(data["request_for_quotation_ids"]) if data["request_for_quotation_ids"] else ([] as Array[RequestForQuotation])
	#self.shipments = Shipment.array_from_dict_id(data["shipment_ids"]) if data["shipment_ids"] else ([] as Array[Shipment])
#
#
#static func array_to_dict(data: Array[Party]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Party in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Party]:
	#var array: Array[Party]
	#for item: Dictionary in data:
		#array.append(Party.from_dict(item))
	#return array
