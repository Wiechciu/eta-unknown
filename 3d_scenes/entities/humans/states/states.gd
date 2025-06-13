extends Node


var update_frequency: float = 0.01
var timer: float = 0.0

var player: Player
var state_items: Array[StateItem]
@export var state_item_scene: PackedScene
@export var item_container: Container


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	if player.person == null:
		await player.person_assigned
	
	clear_container()
	populate_container()


func _process(delta: float) -> void:
	timer += delta
	if timer >= update_frequency:
		update_states()
		timer = 0.0


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	state_items.clear()


func populate_container() -> void:
	for state_data: StateData in player.person.states:
		add_state(state_data)


func add_state(state_data: StateData) -> void:
	var new_state_item: StateItem = (state_item_scene.instantiate() as StateItem).with_data(state_data)
	item_container.add_child(new_state_item)
	state_items.append(new_state_item)


func update_states() -> void:
	for state_item: StateItem in state_items:
		state_item.update_value()
