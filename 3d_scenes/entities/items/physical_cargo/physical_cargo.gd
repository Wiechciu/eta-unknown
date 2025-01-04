class_name PhysicalCargo
extends RigidBody3D


@export var collision_shape: CollisionShape3D
var shipment: Shipment
var is_picked_up: bool


func _ready() -> void:
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	pick_up(node)


func pick_up(node: Node) -> void:
	if !is_picked_up and node is Player:
		var player: Player = node as Player
		player.inventory.pick_up_cargo(self)
