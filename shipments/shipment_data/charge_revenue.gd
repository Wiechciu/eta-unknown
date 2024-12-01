class_name ChargeRevenue
extends Charge


func with_data(code_to_assign: Charge.Code, amount_to_assign: float, currency_to_assign: Currency, party_to_assign: Party) -> ChargeRevenue:
	self.code = code_to_assign
	self.amount = amount_to_assign
	self.currency = currency_to_assign
	self.party = party_to_assign
	return self


func from_cost_with_margin(charge_cost: ChargeCost, margin_percentage: float, margin_amount: float, party_to_assign: Party) -> ChargeRevenue:
	return with_data(charge_cost.code, charge_cost.amount * (1 + margin_percentage) + margin_amount, charge_cost.currency, party_to_assign)
