class_name Printer
extends StaticBody3D


@export var document_spawn_position: Node3D
@export var document_target_position: Node3D
@export var screen: Label3D
@export var document_scene: PackedScene
var printing_queue: Array[PhysicalDocument]
var is_printing: bool


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	screen.text = "%s" % printing_queue.size()
	try_printing_next_document()


func register_interactable() -> void:
	for child: Node in get_children():
		var interactable: Interactable = child as Interactable
		if interactable != null:
			interactable.interacted.connect(interact)


func interact() -> void:
	add_document_to_queue()


func add_document_to_queue() -> void:
	var document: PhysicalDocument = document_scene.instantiate() as PhysicalDocument
	printing_queue.append(document)


func try_printing_next_document() -> void:
	if is_printing:
		return
	var document: PhysicalDocument = printing_queue.pop_front()
	if document == null:
		return
	
	is_printing = true
	add_child(document)
	document.position = document_spawn_position.position
	document.rotation.x = deg_to_rad(-90)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(new_position: Vector3) -> void: document.position = new_position, document_spawn_position.position, document_target_position.position, 1.0)
	await tween.finished
	is_printing = false
