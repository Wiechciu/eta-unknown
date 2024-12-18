class_name Inventory
extends Node


var items: Array[Item]


func add_item(item: Item) -> void:
	items.append(item)
	#print("Added %s to inventory. Currently has %s items." % [item, items.size()])
	
	if item is PhysicalDocument:
		(item as PhysicalDocument).sign_document((get_parent() as Human).person)
		#ActionLogger.create_log("SIGNED_DOCUMENT")


func remove_item(item: Item) -> void:
	items.erase(item)


func remove_all() -> void:
	items.clear()
