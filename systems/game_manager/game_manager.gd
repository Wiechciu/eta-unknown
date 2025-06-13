extends Node


signal difficulty_changed


enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
}

@export var main_scene: PackedScene
@export var json_loader: JsonLoader
var player: Player
var difficulty: Difficulty


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(create_new_shipments)


func create_new_shipments() -> void:
	for customer: Party in GlobalRefs.customers_with_employees:
		var chance_to_create: float = 0.02
		if randf() > chance_to_create:
			continue
		
		for i: int in randi_range(0, 5):
			customer.create_new_request_for_quotation()
	
	var counter: int = 0
	var max_to_accept: int = 5
	for shipment: Shipment in GlobalRefs.shipments_not_owned:
		counter += 1
		if counter > max_to_accept:
			break
		shipment.accept(player.person.employer)


@warning_ignore("shadowed_variable")
func change_difficulty(difficulty: Difficulty) -> void:
	self.difficulty = difficulty
	difficulty_changed.emit()
