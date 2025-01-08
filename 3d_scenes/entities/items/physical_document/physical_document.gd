class_name PhysicalDocument
extends Item


@export var document: Document
var signed_by: Person
var is_signed: bool:
	get: return signed_by != null
@export var group_area: Area3D


func _ready() -> void:
	if document != null:
		with_data(document)
	
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()


@warning_ignore("shadowed_variable")
func with_data(document: Document) -> PhysicalDocument:
	self.document = document
	self.item_name = document.name
	
	return self


func sign_document(person: Person) -> void:
	signed_by = person


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	pick_up_documents(node)


func pick_up_documents(node: Node) -> void:
	var documents_in_group: Array[PhysicalDocument]
	for body: Node3D in group_area.get_overlapping_bodies():
		if body is PhysicalDocument:
			documents_in_group.append(body)
	
	var inventory: Inventory = UtilityTools.get_child_of_type(node, Inventory) as Inventory
	if inventory == null:
		print("No inventory found.")
		return
	
	for physical_document: PhysicalDocument in documents_in_group:
		inventory.add_item(physical_document)
	
	ActionLogger.create_log(tr("PICKED_UP_DOCUMENTS").format({"amount":documents_in_group.size()}))
