#TODO Change SupplyData with Supply, the same with StateData and SkillData
class_name Supply
extends Resource


@export var supply_data: SupplyData
@export var amount_stored: float


var amount_percentage: float:
	get:
		return amount_stored / supply_data.amount_capacity
var is_out_of_supply: bool:
	get:
		return amount_stored < supply_data.amount_per_use
