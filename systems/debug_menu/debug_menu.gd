extends Control


@export var new_shipping_order_template: PackedScene


func _on_new_shipping_order_pressed() -> void:
	var new_shipping_order = new_shipping_order_template.instantiate()
	
	get_tree().root.add_child(new_shipping_order)
	new_shipping_order.position.x = 300
