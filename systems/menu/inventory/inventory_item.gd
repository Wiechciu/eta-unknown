class_name InventoryItem
extends Control


signal remove_button_pressed


var items: Array[Item]
@export var item_count_label: Label
@export var item_name_label: Label
@export var item_icon_rect: TextureRect
@export var checkbox_button: Button
@export var remove_button: Button


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	remove_button.pressed.connect(remove_button_pressed.emit)


@warning_ignore("shadowed_variable")
func initialize(item: Item) -> InventoryItem:
	self.items.append(item)
	self.item_count_label.text = str(items.size())
	self.item_name_label.text = item.item_name
	self.item_icon_rect.texture = item.item_icon
	
	return self


func add_item(item: Item) -> void:
	items.append(item)
	item_count_label.text = str(items.size())


func remove_item(item: Item) -> void:
	items.erase(item)
	item_count_label.text = str(items.size())


func get_tooltip_icon() -> Texture2D:
	return null


func get_tooltip_header() -> String:
	if items.is_empty():
		return ""
	
	return "%s (%d)" % [items[0].item_name, items.size()]


func get_tooltip_body() -> String:
	if items.is_empty():
		return ""
	
	return items[0].item_description
