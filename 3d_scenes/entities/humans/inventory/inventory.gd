class_name Inventory
extends Node


var items: Array[Item]

var is_open: bool:
	get:
		return inventory_visual.visible
@export var inventory_visual: Control
@export var item_container: Control
@export var inventory_item_scene: PackedScene
var inventory_items: Array[InventoryItem]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
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
