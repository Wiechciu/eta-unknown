class_name TmsCharge
extends Node


@export var _code: Label
@export var _name: Label
@export var _amount: Label
@export var _currency: Label
@export var _party: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(charge: Charge) -> TmsCharge:
	_code.text = charge.code_string
	_name.text = charge.name
	_amount.text = charge.amount_string
	_currency.text = charge.currency.code
	_party.text = charge.party.name
	
	return self
