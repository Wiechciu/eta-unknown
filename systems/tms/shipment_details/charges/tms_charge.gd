class_name TmsCharge
extends Node


var charge: Charge
@export var code_label: Label
@export var name_label: Label
@export var amount_label: Label
@export var currency_label: Label
@export var party_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


@warning_ignore("shadowed_variable")
func with_data(charge: Charge) -> TmsCharge:
	self.charge = charge
	code_label.text = charge.charge_data.code
	name_label.text = charge.charge_data.name
	amount_label.text = charge.amount_string
	currency_label.text = charge.currency.code
	party_label.text = charge.party.name
	
	return self
