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
func initialize(charge: Charge) -> TmsCharge:
	self.charge = charge
	self.code_label.text = charge.charge_data.code
	self.name_label.text = charge.charge_data.name
	self.amount_label.text = charge.amount_string
	self.currency_label.text = charge.currency.code
	self.party_label.text = charge.party.name
	
	return self
