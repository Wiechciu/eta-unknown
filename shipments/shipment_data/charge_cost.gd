class_name ChargeCost
extends Charge


@warning_ignore("shadowed_variable", "shadowed_variable_base_class")
func with_data(code: Charge.Code, amount: float, currency: Currency, party: Party) -> ChargeCost:
	self.code = code
	self.amount = amount
	self.currency = currency
	self.party = party
	
	return self
