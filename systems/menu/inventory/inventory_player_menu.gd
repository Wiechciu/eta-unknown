class_name InventoryPlayerMenu
extends Node


var inventory: Inventory
@export var item_container: Control
@export var inventory_item_scene: PackedScene
var inventory_items: Array[InventoryItem]

@export var throw_info_container: Control
@export var throw_label: Label
@export var hold_progress_bar: ProgressBar
var hold_tween: Tween
var hold_tween_duration: float = 1.0


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	var player: Player = UtilityTools.get_parent_of_type(self, Player)
	
	inventory = UtilityTools.get_child_of_type(player, Inventory)
	inventory.item_added.connect(add_item)
	inventory.item_removed.connect(remove_item)
	inventory.cargo_picked_up.connect(on_cargo_picked_up.unbind(1))
	inventory.cargo_thrown.connect(on_cargo_thrown.unbind(1))
	
	clear_container()
	populate_container()
	throw_info_container.modulate.a = 0.0
	hold_progress_bar.max_value = inventory.max_throw_force


func _unhandled_input(event: InputEvent) -> void:
	if inventory.held_cargo != null and event.is_action_pressed("throw"):
		hold_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		hold_tween.tween_method(
			func(amount: float) -> void:
				inventory.throw_force = amount
				hold_progress_bar.value = amount,
			0.0, inventory.max_throw_force, hold_tween_duration)
	
	if inventory.held_cargo != null and event.is_action_released("throw"):
		inventory.throw_cargo()
		if hold_tween:
			hold_tween.kill()
		hold_progress_bar.value = 0.0


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localization()


func update_localization() -> void:
	if not is_node_ready():
		await ready
	var event_text: String = "[%s]" % (InputMap.action_get_events("throw")[0] as InputEventKey).as_text_physical_keycode()
	throw_label.text = tr("HOLD_TO_THROW").format({"action": event_text})


func add_item(item: Item) -> void:
	var found_similar_item: bool = false
	for inventory_item: InventoryItem in inventory_items:
		if inventory_item.items[0].item_name == item.item_name:
			inventory_item.add_item(item)
			found_similar_item = true
			break
	if not found_similar_item:
		var new_inventory_item: InventoryItem = (inventory_item_scene.instantiate() as InventoryItem).initialize(item)
		item_container.add_child(new_inventory_item)
		inventory_items.append(new_inventory_item)
		new_inventory_item.remove_button_pressed.connect(on_remove_button_pressed.bind(new_inventory_item))


func add_items(items_to_add: Array[Item]) -> void:
	for item: Item in items_to_add:
		add_item(item)


func remove_item(item: Item) -> void:
	for inventory_item: InventoryItem in inventory_items:
		if inventory_item.items.has(item):
			inventory_item.remove_item(item)
			if inventory_item.items.size() <= 0:
				inventory_items.erase(inventory_item)
				inventory_item.queue_free()
			break


func remove_items(items_to_remove: Array[Item]) -> void:
	for item: Item in items_to_remove:
		remove_item(item)


func clear_container() -> void:
	for child: Node in item_container.get_children():
		child.queue_free()
	inventory_items.clear()


func populate_container() -> void:
	add_items(inventory.items)


func on_cargo_picked_up() -> void:
	throw_info_container.modulate.a = 1.0


func on_cargo_thrown() -> void:
	throw_info_container.modulate.a = 0.0


func on_remove_button_pressed(inventory_item: InventoryItem) -> void:
	remove_item(inventory_item.items.back())
