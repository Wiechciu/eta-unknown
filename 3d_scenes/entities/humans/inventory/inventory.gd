class_name Inventory
extends Node


signal item_added(item: Item)
signal item_removed(item: Item)
signal cargo_picked_up(cargo: PhysicalCargo)
signal cargo_thrown(cargo: PhysicalCargo)


var player: Player
var items: Array[Item]

var held_cargo: PhysicalCargo
var last_held_cargo: PhysicalCargo
var holding_position_offset: Vector3 = Vector3(0, -1.5, -1.5) ##FIXME: cargo can have different sizes, so it has to be dynamic somehow
var throw_force: float
var max_throw_force: float = 5.0
var pick_up_tween: Tween
var pick_up_tween_duration: float = 0.5

var hold_tween: Tween
var hold_tween_duration: float = 1.0


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	if player == null:
		#FIXME: should be working for all Humans
		queue_free()
		return
	player.inventory = self


func add_item(item: Item) -> void:
	items.append(item)
	
	# TODO: Remove from here when proper signing is implemented.
	if item is PhysicalDocument:
		(item as PhysicalDocument).sign_document((get_parent() as Human).person)
	
	item.get_parent().remove_child(item)
	
	item_added.emit(item)


func add_items(items_to_add: Array[Item]) -> void:
	for item: Item in items_to_add:
		add_item(item)


func remove_item(item: Item) -> void:
	items.erase(item)
	item_removed.emit(item)


func remove_items(items_to_remove: Array[Item]) -> void:
	for item: Item in items_to_remove:
		remove_item(item)


func pick_up_cargo(cargo: PhysicalCargo) -> void:
	if held_cargo != null:
		return
	held_cargo = cargo
	last_held_cargo = cargo
	held_cargo.reparent(player.head)
	(UtilityTools.get_child_of_type(held_cargo, CollisionShape3D) as CollisionShape3D).disabled = true
	held_cargo.freeze = true
	held_cargo.is_picked_up = true
	
	if pick_up_tween != null and pick_up_tween.is_valid():
		pick_up_tween.kill()
	pick_up_tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	pick_up_tween.tween_property(held_cargo, "position", holding_position_offset, pick_up_tween_duration)
	pick_up_tween.tween_property(held_cargo, "rotation", Vector3.ZERO, pick_up_tween_duration)
	
	cargo_picked_up.emit(held_cargo)


func throw_cargo() -> void:
	if held_cargo == null:
		return
	
	if pick_up_tween != null and pick_up_tween.is_valid():
		pick_up_tween.kill()
	held_cargo.reparent(get_tree().current_scene)
	(UtilityTools.get_child_of_type(held_cargo, CollisionShape3D) as CollisionShape3D).disabled = false
	held_cargo.freeze = false
	held_cargo.is_picked_up = false
	held_cargo = null
	
	var direction: Vector3 = player.head.global_transform.basis * (Vector3.FORWARD + Vector3.UP)
	last_held_cargo.apply_impulse(direction * throw_force)
	
	cargo_thrown.emit(last_held_cargo)
