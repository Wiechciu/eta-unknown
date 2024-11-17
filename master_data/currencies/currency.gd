class_name Currency
extends Resource


static var all: Array[Currency]
static var all_dict: Dictionary[String, Currency]


var code: String
var name: String
var exchange_rate_to_usd: float


func get_exchange_rate_to(other_currency: Currency) -> float:
	return exchange_rate_to_usd / other_currency.exchange_rate_to_usd
