class_name PhysicalCargo
extends RigidBody3D


@export var collision_shape: CollisionShape3D
var shipment: Shipment
var is_picked_up: bool


func _ready() -> void:
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = GlobalDebugger.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	if is_picked_up:
		drop_down()
	else:
		pick_up(node)


func pick_up(node: Node) -> void:
	if node is Player:
		var player: Player = node as Player
		reparent(player.head)
		#collision_shape.disabled = true
		freeze = true
		is_picked_up = true


func drop_down() -> void:
	reparent(get_tree().current_scene)
	freeze = false
	#collision_shape.disabled = false
	is_picked_up = false
