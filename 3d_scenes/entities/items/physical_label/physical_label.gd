class_name PhysicalLabel
extends Item


var document: Document
@export var group_area: Area3D


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()


@warning_ignore("shadowed_variable")
func with_data(document: Document) -> PhysicalLabel:
	self.document = document
	self.item_name = document.name
	
	return self


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	pick_up_labels(node)


func pick_up_labels(node: Node) -> void:
	var labels_in_group: Array[PhysicalLabel]
	for body: Node3D in group_area.get_overlapping_bodies():
		if body is PhysicalLabel:
			labels_in_group.append(body)
	
	var inventory: Inventory = UtilityTools.get_child_of_type(node, Inventory) as Inventory
	if inventory == null:
		print("No inventory found.")
		return
	
	for physical_label: PhysicalLabel in labels_in_group:
		inventory.add_item(physical_label)
		physical_label.get_parent().remove_child(physical_label)
	
	ActionLogger.create_log(tr("PICKED_UP_DOCUMENTS").format({"amount":labels_in_group.size()}))
