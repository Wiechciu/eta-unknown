class_name TooltipComponent
extends Node


@export var tooltip_scene: PackedScene
var parent: Control
var tooltip: Tooltip


func _ready() -> void:
	parent = get_parent()
	
	if		not parent is Control or \
			not parent.has_method("get_tooltip_body") or \
			parent.get_tooltip_body() == "":
		queue_free()
		return
	
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	
	if parent.has_signal("tooltip_retrigger"):
		parent.tooltip_retrigger.connect(create_tooltip)


func _on_mouse_entered() -> void:
	create_tooltip()


func _on_mouse_exited() -> void:
	destroy_tooltip()


func _on_tooltip_retrigger() -> void:
	if tooltip != null:
		create_tooltip()


func create_tooltip() -> void:
	destroy_tooltip()
	
	var tooltip_icon: Texture2D = parent.get_tooltip_icon() if parent.has_method("get_tooltip_icon") else null
	var tooltip_header: String = parent.get_tooltip_header() if parent.has_method("get_tooltip_header") else ""
	var tooltip_body: String = parent.get_tooltip_body() if parent.has_method("get_tooltip_body") else ""
	
	tooltip = (tooltip_scene.instantiate() as Tooltip).initialize(tooltip_icon, tooltip_header, tooltip_body)
	get_tree().root.add_child(tooltip)
	tooltip.fade_in()


func destroy_tooltip() -> void:
	if tooltip != null:
		tooltip.fade_out()
