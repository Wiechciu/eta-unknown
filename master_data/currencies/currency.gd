class_name Currency
extends Resource


@export var id: int
@export var code: String
@export var name: String
@export var exchange_rate_to_usd: float


@warning_ignore("shadowed_variable")
static func create_new(id: int, code: String, name: String, exchange_rate_to_usd: float) -> Currency:
	var new_currency: Currency = Currency.new()
	new_currency.id = id
	new_currency.code = code
	new_currency.name = name
	new_currency.exchange_rate_to_usd = exchange_rate_to_usd
	
	GlobalRefs.currencies.append(new_currency)
	
	return new_currency


@warning_ignore("shadowed_variable")
static func get_by_code(code: String) -> Currency:
	for currency: Currency in GlobalRefs.currencies:
		if currency.code.to_lower() == code.to_lower():
			return currency
	
	printerr("Could't find currency code: " + code)
	return null


func get_exchange_rate_to(other_currency: Currency) -> float:
	return exchange_rate_to_usd / other_currency.exchange_rate_to_usd


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"code" = code,
		#"name" = name,
		#"exchange_rate_to_usd" = exchange_rate_to_usd,
	#}
#
#
#static func from_dict(data: Dictionary) -> Currency:
	#return Currency.new().with_data(
		#data["id"],
		#data["code"],
		#data["name"],
		#data["exchange_rate_to_usd"],
	#)
#
#
#static func array_to_dict(data: Array[Currency]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Currency in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Currency]:
	#var array: Array[Currency]
	#for item: Dictionary in data:
		#array.append(Currency.from_dict(item))
	#return array
