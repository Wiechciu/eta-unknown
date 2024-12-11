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
	
	return self


func get_exchange_rate_to(other_currency: Currency) -> float:
	return exchange_rate_to_usd / other_currency.exchange_rate_to_usd
