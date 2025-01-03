class_name DropLocationFinder
extends RayCast3D


signal on_hover_started
signal on_hover_ended

var interactable: Interactable
var old_collider: Object


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	check_for_interactable()


func check_for_interactable() -> void:
	var new_collider: Object = get_collider()
	if new_collider == old_collider:
		return
	
	if interactable != null:
		on_hover_ended.emit()
		interactable.on_hover_end()
	
	old_collider = new_collider
	interactable = UtilityTools.get_child_of_type(new_collider as Node, Interactable) as Interactable
	if interactable != null:
		on_hover_started.emit()
		interactable.on_hover_start()


func interact(node: Node) -> void:
	if interactable != null:
		interactable.interact(node)
