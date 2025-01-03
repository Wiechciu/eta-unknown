class_name DropLocationFinder
extends RayCast3D


var inventory: Inventory


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	var player: Player = UtilityTools.get_parent_of_type(self, Player) as Player
	inventory = UtilityTools.get_child_of_type(player, Inventory) as Inventory
	#TODO: allow for precise drop off of the cargo to the selected position instead of throwing.
