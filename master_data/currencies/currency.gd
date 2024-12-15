class_name Currency
extends Resource


var id: int
var code: String
var name: String
var exchange_rate_to_usd: float


@warning_ignore("shadowed_variable")
func with_data(id: int, code: String, name: String, exchange_rate_to_usd: float) -> Currency:
	self.id = id
	self.code = code
	self.name = name
	self.exchange_rate_to_usd = exchange_rate_to_usd
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.currencies.append(self)
	@warning_ignore("unsafe_property_access")
	GlobalRefs.currencies_dict[id] = self
	@warning_ignore("unsafe_property_access")
	GlobalRefs.currencies_code_dict[code] = self
	
	return self


func get_exchange_rate_to(other_currency: Currency) -> float:
	return exchange_rate_to_usd / other_currency.exchange_rate_to_usd


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"code" = code,
		"name" = name,
		"exchange_rate_to_usd" = exchange_rate_to_usd,
	}


static func from_dict(data: Dictionary) -> Currency:
	return Currency.new().with_data(
		data["id"],
		data["code"],
		data["name"],
		data["exchange_rate_to_usd"],
	)


static func array_to_dict(data: Array[Currency]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Currency in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Currency]:
	var array: Array[Currency]
	for item: Dictionary in data:
		array.append(Currency.from_dict(item))
	return array
