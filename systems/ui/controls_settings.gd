class_name ControlsSettings
extends PanelContainer


@export var container: Control
@export var list_item_scene: PackedScene


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	refresh_container()


func refresh_container() -> void:
	if not visible:
		return
	clear_container()
	populate_container()


func clear_container() -> void:
	for child: Node in container.get_children():
		child.queue_free()


func populate_container() -> void:
	for action_name: String in InputMap.get_actions():
		if action_name.begins_with("ui"):
			continue
		var list_item: ControlsListItem = (list_item_scene.instantiate() as ControlsListItem).with_data(action_name)
		container.add_child(list_item)
