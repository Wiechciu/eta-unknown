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

const NAME_PREFIXES: Array[String] = [
	"Global", "Prime", "Next", "Ultra", "Dynamic", "Rapid", "Pioneer", "Vertex", "Summit", "Nexus",
	"Quantum", "Apex", "Echo", "Iron", "Nova", "Atlas", "Vortex", "Pulse", "Fusion", "Crystal",
	"True", "Bright", "Deep", "Blue", "Green", "Solid", "Clear", "Open", "Swift", "Urban",
	"Golden", "Silver", "Royal", "Future", "Bold", "Stellar", "Gravity", "Arc", "Meta", "Core",
	"Omni", "Solar", "Lunar", "Zenith", "Neo", "Magna", "Alpha", "Beta", "Sigma", "Horizon",
	"Hyper", "Turbo", "Smart", "Echo", "Trans", "Opti", "Cyber", "Neon", "Iron", "Fire",
	"Digital", "Mono", "Hexa", "Tri", "One", "Infini", "Nova", "Epic", "Axial", "Proto",
	"Astro", "Nano", "Max", "Elevate", "Nimbus", "Velvet", "Spectra", "Drift", "North", "West",
	"Cobalt", "Amber", "Orchid", "Ivory", "Crimson", "Azure", "Chrome", "Zebra", "Oasis", "Frost",
	"Nimbus", "Zen", "Ironwood", "Truepoint", "Skyward", "Topline", "Vertexa", "Equinox", "Tranquil", "Silent",
	"Delta", "Strato", "Centra", "Arch", "Polaris", "Eon", "Beacon", "Lumen", "Corewave", "Frontline"
]
const NAME_BUZZWORDS: Array[String] = [
	"Solutions", "Systems", "Networks", "Technologies", "Concepts", "Industries", "Dynamics", "Ventures", "Enterprises", "Holdings",
	"Analytics", "Capital", "Strategies", "Group", "Logics", "Matrix", "Node", "Design", "Fabric", "Layer",
	"Circle", "Bridge", "Edge", "Chain", "Sphere", "Flow", "Source", "Point", "Works", "Path",
	"Labs", "Forge", "Spark", "Thread", "Nest", "Guild", "Union", "Platform", "Grid", "Stack",
	"Studio", "Verse", "Cloud", "Engine", "Factor", "Orbit", "Panel", "Frame", "Beacon", "Anchor",
	"Delta", "Core", "Crate", "Link", "Depot", "Realm", "Port", "Fleet", "Logic", "Task",
	"Dock", "Hub", "Hive", "Loop", "Layer", "Module", "Tier", "Unit", "Axis", "Point",
	"Chronicle", "Vault", "Mirror", "Portion", "Access", "Nucleus", "Vision", "Thread", "Merge", "Pulse",
	"Horizon", "Drift", "Wave", "Pilot", "Cell", "Drop", "Rise", "Stretch", "Play", "Cellar",
	"Engine", "Field", "Array", "Note", "Lab", "Solutioneers", "Roots", "Meadow", "Dockyard", "Cluster",
	"Storm", "Vector", "Branch", "Stack", "Frame", "Boost", "Drill", "Machine", "Line", "Beam",
	"Motion", "Linker", "Craft", "Sparkle", "Sprout", "Growth", "Vault", "Runner", "Map", "Pipeline"
]
const NAME_SUFFIXES: Array[String] = [
	"Inc", "LLC", "Corp", "Ltd", "Group", "Co", "PLC", "GmbH", "S.A.", "Partners",
	"Consulting", "Studios", "Collective", "Associates", "Consortium", "Works", "Agency", "Initiative", "Syndicate", "Authority",
	"Solutions", "Ventures", "Holdings", "Industries", "Enterprises", "Networks", "Systems", "Technologies", "Logistics", "Dynamics",
	"International", "Worldwide", "Global", "Union", "Federation", "Labs", "Node", "Core", "Outfit", "Engineers",
	"Machines", "Architects", "Creators", "Makers", "Builders", "Pioneers", "Minds", "Catalysts", "Executors", "Operators",
	"Council", "Commission", "Exchange", "Studio", "Haven", "Nest", "Vault", "Realm", "Deck", "Fellows",
	"Thinktank", "Conglomerate", "Sons", "Brothers", "Guild", "Club", "League", "Society", "Crüe", "Syndicate",
	"Associates", "Advisors", "Thinkers", "Shapers", "Navigators", "Mechanics", "Crafters", "Boosters", "Explorers", "Nexus",
	"People", "Collective", "Front", "Foundation", "Empire", "Network", "Stack", "Matrix", "Cloud", "Forge",
	"One", "360", "Plus", "Zero", "X", "Pro", "Max", "Edge", "Link", "Shift"
]
const STREET_PREFIXES: Array[String] = [
	"Oak", "Pine", "Maple", "Cedar", "Elm", "Ash", "Birch", "Willow", "Holly",
	"Chestnut", "Spruce", "Sycamore", "Walnut", "Redwood", "Dogwood", "Beech",
	"Cottonwood", "Alder", "Juniper", "Sequoia", "Magnolia", "Hickory", "Laurel",
	"Mulberry", "Poplar", "Rowan", "Aspen", "Yew", "Fir", "Linden", "Grove",
	"Highland", "Ridge", "Hill", "Valley", "Lake", "River", "Creek", "Spring",
	"Brook", "Forest", "Canyon", "Meadow", "Field", "Park", "Bay", "Shore",
	"Island", "Bluff", "Cliff", "Trail", "Path", "Vista", "Summit", "Glade",
	"Stone", "Iron", "Silver", "Gold", "Crystal", "Shadow", "Sunset", "Twilight"
]
const STREET_SUFFIXES: Array[String] = [
	"Street", "Avenue", "Road", "Boulevard", "Drive", "Lane", "Way", "Court",
	"Circle", "Terrace", "Place", "Loop", "Parkway", "Alley", "Run", "Commons",
	"Pass", "Square", "Heights", "Crossing", "Row", "Point", "Hollow", "View",
	"Garden", "Walk", "Crescent", "Glen", "Landing", "Plaza", "Reach", "Turn"
]
const CITY_PREFIXES: Array[String]  = [
	"Green", "North", "South", "East", "West",
	"Lake", "River", "Hill", "Spring", "Clear",
	"New", "Fort", "Port", "Mount", "Grand",
	"High", "Low", "Sunny", "Silver", "Golden",
	"Red", "Blue", "White", "Black", "Stone",
	"Oak", "Pine", "Maple", "Cedar", "Willow",
	"Iron", "Ash", "Bright", "Shadow", "Cloud",
	"Storm", "Frost", "Dust", "Glade", "Crystal",
	"Fog", "Drift", "Sun", "Moon", "Star",
	"Falcon", "Wolf", "Bear", "Fox", "Eagle",
	"Copper", "Bronze", "Steel", "Obsidian", "Quartz",
	"Wind", "Snow", "Rain", "Thunder", "Blaze",
	"Cinder", "Ember", "Flint", "Clay", "Slate",
	"Marble", "Granite", "Moss", "Boulder", "Pebble",
	"Branch", "Thorn", "Vine", "Briar", "Bloom",
	"Thistle", "Ivy", "Lily", "Fern", "Dawn",
	"Dusk", "Aurora", "Echo", "Zephyr", "Nimbus",
	"Comet", "Nova", "Hawk", "Falco", "Griffin",
	"Dragon", "Raven", "Crow", "Lynx", "Otter",
	"Badger", "Elk", "Moose", "Coyote", "Cougar"
]
const CITY_SUFFIXES: Array[String]  = [
	"ton", "ville", "burg", "borough", "bury",
	"stead", "land", "field", "ford", "view",
	"mouth", "port", "gate", "dale", "wood",
	"ridge", "haven", "heights", "cove", "springs",
	"hollow", "falls", "meadows", "valley", "cross",
	"grove", "creek", "bluff", "point", "bay",
	"cliff", "reach", "bend", "mead", "nook",
	"well", "mill", "rock", "run", "shore",
	"peak", "summit", "divide", "line", "cut",
	"chasm", "basin", "pines", "trees", "forest",
	"woods", "branches", "stones", "rocks", "hills",
	"pasture", "trail", "pass", "bridge", "arch",
	"archway", "terrace", "circle", "loop", "row",
	"walk", "lane", "path", "way", "outlook",
	"watch", "station", "camp", "depot", "yard",
	"junction", "hub", "delta", "flats", "banks",
	"shoreline", "firth", "strand", "harbor", "havenport",
	"cairn", "ledge", "crag", "den", "hatch",
	"rise", "ridgeway", "valewood", "fen", "marsh",
	"bog", "isle", "key", "reef", "wharf"
]
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
	var new_party: Party = Party.new().with_data(
		GlobalRefs.get_party_id(),
		randi_range(0, Party.Type.size() - 1), ##TODO: fix to make some it more diverse type by implementing probabilities. The same with person genders later with the probabilities
		get_unique_name(),
		STREET_PREFIXES.pick_random() + STREET_SUFFIXES.pick_random(),
		str(randi_range(1, 100)),
		str(randi_range(1, 100)),
		str(randi_range(10000, 99999)),
		CITY_PREFIXES.pick_random() + CITY_SUFFIXES.pick_random(),
		GlobalRefs.countries.pick_random(),
		[] as Array[Person],
		0.0,
		[] as Array[RequestForQuotation],
		[] as Array[Shipment],
		100000,
		0.0,
		0.0,
		0.0,
		)
	
	if new_party.is_supplier:
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


@warning_ignore("shadowed_variable")
func with_data(id: int, type: Type, name: String, street_name: String, street_number: String, house_number: String, postal_code: String, city_name: String, country: Country, employees: Array[Person], balance: float, requests_for_quotation: Array[RequestForQuotation], shipments: Array[Shipment], last_shipment_number: int, total_earnings: float, reliability_factor: float, cost_factor: float) -> Party:
	self.id = id
	self.type = type
	self.name = name
	self.street_name = street_name
	self.street_number = street_number
	self.house_number = house_number
	self.postal_code = postal_code
	self.city_name = city_name
	self.country = country
	self.employees = employees
	self.balance = balance
	
	self.requests_for_quotation = requests_for_quotation
	self.shipments = shipments
	
	self.last_shipment_number = last_shipment_number
	self.total_earnings = total_earnings
	
	self.reliability_factor = reliability_factor
	self.cost_factor = cost_factor
	
	self.domain = generate_domain_for_company_name(self.name)
	
	GlobalRefs.parties.append(self)
	GlobalRefs.parties_dict[id] = self
	
	match self.type:
		Party.Type.CUSTOMER:
			GlobalRefs.customers.append(self)
			GlobalRefs.customers_dict[self.id] = self
		Party.Type.FREIGHT_FORWARDER:
			GlobalRefs.freight_forwarders.append(self)
			GlobalRefs.freight_forwarders_dict[self.id] = self
		Party.Type.CARRIER:
			GlobalRefs.carriers.append(self)
			GlobalRefs.carriers_dict[self.id] = self
		Party.Type.CUSTOMS_AGENCY:
			GlobalRefs.customs_agencies.append(self)
			GlobalRefs.customs_agencies_dict[self.id] = self
		Party.Type.HANDLING_AGENT:
			GlobalRefs.handling_agents.append(self)
			GlobalRefs.handling_agents_dict[self.id] = self
		Party.Type.TRUCKER:
			GlobalRefs.truckers.append(self)
			GlobalRefs.truckers_dict[self.id] = self
	
	if self.is_supplier:
		GlobalRefs.suppliers.append(self)
		GlobalRefs.suppliers_dict[self.id] = self

	return self


func generate_domain_for_company_name(company_name: String) -> String:
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
	var new_request: RequestForQuotation = RequestForQuotation.new().with_data_random(self)
	if new_request != null:
		requests_for_quotation.append(new_request)


func create_new_shipment() -> void:
	var new_shipment: Shipment = Shipment.new().with_data_random(self, null)
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
