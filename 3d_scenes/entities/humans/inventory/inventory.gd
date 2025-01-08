class_name Inventory
extends Node


var player: Player
var items: Array[Item]

var is_open: bool:
	get:
		return inventory_visual.visible
@export var inventory_visual: Control
@export var close_button: Button
@export var item_container: Control
@export var inventory_item_scene: PackedScene
var inventory_items: Array[InventoryItem]

var held_cargo: PhysicalCargo
var last_held_cargo: PhysicalCargo
var holding_position_offset: Vector3 = Vector3(0, -1.5, -1.5) ##FIXME: cargo can have different sizes, so it has to be dynamic somehow
var throw_force: float
var max_throw_force: float = 5.0
var pick_up_tween: Tween
var pick_up_tween_duration: float = 0.5

@export var throw_info_container: Control
@export var throw_label: Label
@export var hold_progress_bar: ProgressBar
var hold_tween: Tween
var hold_tween_duration: float = 1.0


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	player = UtilityTools.get_parent_of_type(self, Player)
	clear_container()
	populate_container()
	close()
	throw_info_container.modulate.a = 0.0
	hold_progress_bar.max_value = max_throw_force
	close_button.pressed.connect(close)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
	
	if held_cargo != null and event.is_action_pressed("throw"):
		hold_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		hold_tween.tween_method(
			func(amount: float) -> void:
				throw_force = amount
				hold_progress_bar.value = amount,
			0.0, max_throw_force, hold_tween_duration)
	
	if held_cargo != null and event.is_action_released("throw"):
		throw_cargo()
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
	items.append(item)
	
	# TODO: Remove from here when proper signing is implemented.
	if item is PhysicalDocument:
		(item as PhysicalDocument).sign_document((get_parent() as Human).person)
	
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
	
	item.get_parent().remove_child(item)


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


func open() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	inventory_visual.show()


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
	pick_up_tween.tween_method(func(alpha: float) -> void: throw_info_container.modulate.a = alpha, 0.0, 1.0, pick_up_tween_duration)


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
	throw_info_container.modulate.a = 0.0
	
	var direction: Vector3 = player.head.global_transform.basis * (Vector3.FORWARD + Vector3.UP)
	last_held_cargo.apply_impulse(direction * throw_force)
