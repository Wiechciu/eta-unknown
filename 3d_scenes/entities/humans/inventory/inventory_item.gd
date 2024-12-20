class_name InventoryItem
extends Control


var item_count: int
var item_name: String
@export var item_count_label: Label
@export var item_name_label: Label


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)


func with_data(item_count: int, item_name: String) -> InventoryItem:
	self.item_count = item_count
	self.item_name = item_name
	self.item_count_label.text = str(item_count)
	self.item_name_label.text = item_name
	
	return self


func increase_count(amount: int) -> void:
	item_count += amount
	item_count_label.text = str(item_count)


func decrease_count(amount: int) -> void:
	item_count -= amount
	item_count_label.text = str(item_count)
