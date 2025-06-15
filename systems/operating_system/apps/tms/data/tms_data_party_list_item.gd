class_name TmsDataPartyListItem
extends Control


signal pressed_with_party_data(party: Party)


var party: Party

@export var party_id: Label
@export var party_name: Label
@export var party_city_and_country: Label
@export var party_type: Label

@export var button: Button


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	button.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func initialize(party: Party) -> TmsDataPartyListItem:
	self.party = party
	
	self.party_id.text = str(party.id)
	self.party_name.text = party.name
	self.party_city_and_country.text = "%s, %s" % [party.city_name, party.country.code]
	self.party_type.text = party.type_as_string
	
	return self


func _on_button_pressed() -> void:
	pressed_with_party_data.emit(party)
