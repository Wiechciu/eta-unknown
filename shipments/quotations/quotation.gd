class_name Quotation
extends Resource


var number: String
var currency: Currency
var rates: Array[Rate]
var total_amount: float:
	get:
		var total: float = 0
		for rate: Rate in rates:
			total += rate.amount
		return total
