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


var id: int
var type: Type
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
	get: return (type == Type.CARRIER or type == Type.CUSTOMS_AGENCY or type == Type.HANDLING_AGENT or type == Type.TRUCKER) 
var reliability_factor: float
var cost_factor: float


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
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.parties.append(self)
	@warning_ignore("unsafe_property_access")
	GlobalRefs.parties_dict[id] = self
	
	return self


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


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"type" = type,
		"name" = name,
		"street_name" = street_name,
		"street_number" = street_number,
		"house_number" = house_number,
		"postal_code" = postal_code,
		"city_name" = city_name,
		"country_id" = country.id if country else "",
		"employee_ids" = Person.array_to_dict_id(employees),
		"balance" = balance,
		"request_for_quotation_ids" = RequestForQuotation.array_to_dict_id(requests_for_quotation),
		"shipment_ids" = Shipment.array_to_dict_id(shipments),
		"last_shipment_number" = last_shipment_number,
		"total_earnings" = total_earnings,
		"reliability_factor" = reliability_factor,
		"cost_factor" = cost_factor
	}


static func from_dict(data: Dictionary) -> Party:
	return Party.new().with_data(
		data["id"],
		data["type"],
		data["name"],
		data["street_name"],
		data["street_number"],
		data["house_number"],
		data["postal_code"],
		data["city_name"],
		GlobalRefs.countries_dict[data["country_id"] as int],
		[] as Array[Person],
		data["balance"],
		[] as Array[RequestForQuotation],
		[] as Array[Shipment],
		data["last_shipment_number"],
		data["total_earnings"],
		data["reliability_factor"],
		data["cost_factor"],
	)


func assign_references_from_dict(data: Dictionary) -> void:
	self.employees = Person.array_from_dict_id(data["employee_ids"]) if data["employee_ids"] else ([] as Array[Person])
	self.requests_for_quotation = RequestForQuotation.array_from_dict_id(data["request_for_quotation_ids"]) if data["request_for_quotation_ids"] else ([] as Array[RequestForQuotation])
	self.shipments = Shipment.array_from_dict_id(data["shipment_ids"]) if data["shipment_ids"] else ([] as Array[Shipment])


static func array_to_dict(data: Array[Party]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Party in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Party]:
	var array: Array[Party]
	for item: Dictionary in data:
		array.append(Party.from_dict(item))
	return array
