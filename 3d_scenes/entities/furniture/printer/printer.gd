class_name Printer
extends ComputerInterface


@export var document_spawn_position: Node3D
@export var document_target_position: Node3D
@export var screen: Label3D
@export var document_scene: PackedScene
@export var audio_player: AudioStreamPlayer3D

var printing_queue: Array[Document]
var is_printing: bool

var printed_documents: Array[PhysicalDocument]


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var number: int = printing_queue.size()
	screen.text = "%s" % number
	if number == 0:
		screen.shaded = true
	else:
		screen.shaded = false
	
	try_printing_next_document()


func register_interactable() -> void:
	var interactable: Interactable = GlobalDebugger.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	pick_up_documents(node)


func pick_up_documents(node: Node) -> void:
	if printed_documents.size() == 0:
		ActionLogger.create_log("NO_DOCUMENTS_TO_PICK_UP", true)
		return
	
	var inventory: Inventory = GlobalDebugger.get_child_of_type(node, Inventory)
	if inventory == null:
		print("No inventory found.")
		return
	
	for physical_document: PhysicalDocument in printed_documents:
		inventory.add_item(physical_document)
		remove_child(physical_document)
	
	ActionLogger.create_log(tr("PICKED_UP_DOCUMENTS").format({"amount":printed_documents.size()}))
	printed_documents.clear()


func add_document_to_queue(document: Document) -> void:
	printing_queue.append(document)


func try_printing_next_document() -> void:
	if is_printing:
		return
	var document: Document = printing_queue.pop_front()
	if document == null:
		return
	
	play_sound()
	print_document(document)


func play_sound() -> void:
	audio_player.pitch_scale = randf_range(0.90, 1.10)
	audio_player.play()


func print_document(document: Document) -> void:
	is_printing = true
	var physical_document: PhysicalDocument = (document_scene.instantiate() as PhysicalDocument).with_data(document)
	add_child(physical_document)
	physical_document.position = document_spawn_position.position
	physical_document.rotation.x = deg_to_rad(-90)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(new_position: Vector3) -> void: physical_document.position = new_position, document_spawn_position.position, document_target_position.position, 1.0)
	await tween.finished
	printed_documents.append(physical_document)
	is_printing = false
