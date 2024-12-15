extends Node


var market_rates_dict: Dictionary[String, float]


func create_market_rates() -> void:
	for first_country: Country in GlobalRefs.countries:
		for second_country: Country in GlobalRefs.countries:
			var market_rate: float = 0
			if first_country != second_country:
				market_rate = snappedf(randf_range(3, 10), 0.01)
			var key: String = first_country.code + second_country.code
			market_rates_dict[key] = market_rate
