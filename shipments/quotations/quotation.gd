class_name Quotation
extends Resource


var number: String
var currency: Currency
var rates: Array[Rate]
var total_amount:
	get:
		var total: float = 0
		for rate in rates:
			total += rate.amount
		return total
