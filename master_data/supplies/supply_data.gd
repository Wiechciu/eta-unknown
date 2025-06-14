#TODO Change SupplyData with Supply, the same with StateData and SkillData
class_name SupplyData
extends Resource


@export var supply: Supply
@export var amount_stored: float


var amount_percentage: float:
	get:
		return amount_stored / supply.amount_capacity
var is_out_of_supply: bool:
	get:
		return amount_stored < supply.amount_per_use
