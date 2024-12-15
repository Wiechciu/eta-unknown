#class_name Customer
#extends Party
#
#
#var requests_for_quotation: Array[RequestForQuotation]
#var shipments: Array[Shipment]
#
#
#func create_new_request_for_quotation() -> void:
	#var new_request: RequestForQuotation = RequestForQuotation.new().with_data_random(self)
	#if new_request != null:
		#requests_for_quotation.append(new_request)
#
#
#func create_new_shipment() -> void:
	#var new_shipment: Shipment = Shipment.new().with_data_random(self, null)
	#if new_shipment != null:
		#shipments.append(new_shipment)
#
#
#@warning_ignore("shadowed_variable")
#func with_data(id: int, name: String, street_name: String, street_number: String, house_number: String, postal_code: String, city_name: String, country: Country, employees: Array[Person], balance: float, requests_for_quotation: Array[RequestForQuotation], shipments: Array[Shipment]) -> Party:
	#self.id = id
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
	#return self
#
#
#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"name" = name,
		#"street_name" = street_name,
		#"street_number" = street_number,
		#"house_number" = house_number,
		#"postal_code" = postal_code,
		#"city_name" = city_name,
		#"country_id" = country.id if country else "",
		#"employee_ids" = Person.array_to_dict_id(employees),
		#"balance" = balance,
		#"request_for_quotation_ids" = RequestForQuotation.array_to_dict_id(requests_for_quotation),
		#"shipment_ids" = Shipment.array_to_dict_id(shipments),
	#}
#
#
#static func from_dict(data: Dictionary) -> Customer:
	#return Customer.new().with_data(
		#data["id"],
		#data["name"],
		#data["street_name"],
		#data["street_number"],
		#data["house_number"],
		#data["postal_code"],
		#data["city_name"],
		#GlobalRefs.countries_dict[data["country_id"]],
		#Person.array_from_dict_id(data["employee_ids"]) if data["employee_ids"] else ([] as Array[Person]),
		#data["balance"],
		#RequestForQuotation.array_from_dict_id(data["request_for_quotation_ids"]) if data["request_for_quotation_ids"] else ([] as Array[RequestForQuotation]),
		#Shipment.array_from_dict_id(data["shipment_ids"]) if data["shipment_ids"] else ([] as Array[Shipment]),
	#)
#
#
#static func array_to_dict(data: Array[Customer]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Customer in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Customer]:
	#var array: Array[Customer]
	#for item: Dictionary in data:
		#array.append(Customer.from_dict(item))
	#return array
