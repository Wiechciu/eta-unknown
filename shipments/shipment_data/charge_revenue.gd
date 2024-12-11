class_name ChargeRevenue
extends Charge


@warning_ignore("shadowed_variable", "shadowed_variable_base_class")
func with_data(code: Charge.Code, amount: float, currency: Currency, party: Party) -> ChargeRevenue:
	self.code = code
	self.amount = amount
	self.currency = currency
	self.party = party
	
	return self


@warning_ignore("shadowed_variable", "shadowed_variable_base_class")
func from_cost_with_margin(charge_cost: ChargeCost, margin_percentage: float, margin_amount: float, party: Party) -> ChargeRevenue:
	return with_data(charge_cost.code, charge_cost.amount * (1 + margin_percentage) + margin_amount, charge_cost.currency, party)
