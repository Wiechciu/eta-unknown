class_name TooltipComponent
extends Node


@export var tooltip_scene: PackedScene
var parent: Control
var tooltip: Tooltip


func _ready() -> void:
	parent = get_parent()
	if not parent.has_method("get_tooltip_header") and not parent.has_method("get_tooltip_body"):
		queue_free()
		return
	
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	create_tooltip()


func _on_mouse_exited() -> void:
	destroy_tooltip()


func create_tooltip() -> void:
	destroy_tooltip()
	
	tooltip = (tooltip_scene.instantiate() as Tooltip).with_data(parent.get_tooltip_header(), parent.get_tooltip_body())
	get_tree().root.add_child(tooltip)


func destroy_tooltip() -> void:
	if tooltip != null:
		tooltip.queue_free()
