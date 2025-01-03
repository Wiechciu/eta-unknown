class_name DropLocationFinder
extends RayCast3D


var inventory: Inventory


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	var player: Player = UtilityTools.get_parent_of_type(self, Player) as Player
	inventory = UtilityTools.get_child_of_type(player, Inventory) as Inventory


func _unhandled_input(event: InputEvent) -> void:
	if inventory.held_cargo != null and event.is_action_pressed("throw"):
		inventory.throw_cargo()


func check_for_interactable() -> void:
	var new_collider: Object = get_collider()
