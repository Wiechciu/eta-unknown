class_name ChargeCost
extends Charge


func with_data(code_to_assign: Charge.Code, amount_to_assign: float, currency_to_assign: Currency, party_to_assign: Party) -> ChargeCost:
	self.code = code_to_assign
	self.amount = amount_to_assign
	self.currency = currency_to_assign
	self.party = party_to_assign
	return self
