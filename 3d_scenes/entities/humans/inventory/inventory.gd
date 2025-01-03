class_name Inventory
extends Node


var player: Player
var items: Array[Item]

var is_open: bool:
	get:
		return inventory_visual.visible
@export var inventory_visual: Control
@export var item_container: Control
@export var inventory_item_scene: PackedScene
var inventory_items: Array[InventoryItem]

var held_cargo: PhysicalCargo
var last_held_cargo: PhysicalCargo
var throw_force: float = 5.0


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	clear_container()
	populate_container()
	close()


func add_item(item: Item) -> void:
	items.append(item)
	#print("Added %s to inventory. Currently has %s items." % [item, items.size()])
	
	if item is PhysicalDocument:
		(item as PhysicalDocument).sign_document((get_parent() as Human).person)
		#ActionLogger.create_log("SIGNED_DOCUMENT")
	
	var found_similar_item: bool = false
	for inventory_item: InventoryItem in inventory_items:
		if inventory_item.item_name == item.item_name:
			inventory_item.increase_count(1)
			found_similar_item = true
			break
	if not found_similar_item:
		var new_inventory_item: InventoryItem = (inventory_item_scene.instantiate() as InventoryItem).with_data(1, item.item_name)
		item_container.add_child(new_inventory_item)
		inventory_items.append(new_inventory_item)


@warning_ignore("shadowed_variable")
func add_items(items: Array[Item]) -> void:
	for item: Item in items:
		add_item(item)


func remove_item(item: Item) -> void:
	items.erase(item)
	
	for inventory_item: InventoryItem in inventory_items:
		if inventory_item.item_name == item.item_name:
			inventory_item.decrease_count(1)
			if inventory_item.item_count <= 0:
				inventory_item.queue_free()
			break


@warning_ignore("shadowed_variable")
func remove_items(items: Array[Item]) -> void:
	for item: Item in items:
		remove_item(item)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if is_open:
			close()
		else:
			open()


func open() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inventory_visual.show()
	#clear_container()
	#await get_tree().process_frame
	#populate_container()


func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventory_visual.hide()


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	inventory_items.clear()


func populate_container() -> void:
	for item: Item in items:
		var found_similar_item: bool = false
		for inventory_item: InventoryItem in inventory_items:
			if inventory_item.item_name == item.item_name:
				inventory_item.add_count(1)
				found_similar_item = true
				break
		if not found_similar_item:
			var new_inventory_item: InventoryItem = (inventory_item_scene.instantiate() as InventoryItem).with_data(1, item.item_name)
			item_container.add_child(new_inventory_item)
			inventory_items.append(new_inventory_item)


func pick_up_cargo(cargo: PhysicalCargo) -> void:
	held_cargo = cargo
	last_held_cargo = cargo
	held_cargo.reparent(player.head)
	held_cargo.freeze = true
	held_cargo.is_picked_up = true


func drop_down_cargo() -> void:
	held_cargo.reparent(get_tree().current_scene)
	held_cargo.freeze = false
	held_cargo.is_picked_up = false
	held_cargo = null


func throw_cargo() -> void:
	drop_down_cargo()
	last_held_cargo.apply_impulse(player.head.global_transform.basis * Vector3.FORWARD * throw_force)
