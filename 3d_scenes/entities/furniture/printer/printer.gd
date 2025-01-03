## TODO: add simple on/off tween for symbols when out of ink or jammed
## TODO: add some visual and sound indication for both servicing 

class_name Printer
extends ComputerInterface


enum Status {
	IDLE,
	PRINTING,
	SERVICING,
}

@export var printer_tray: Node3D
@export var document_spawn_position: Node3D
@export var document_target_position: Node3D
@export var document_scene: PackedScene

@export var screen: Sprite3D
@export var document_count_label: Label
@export var ink_progress_bar: ProgressBar
@export var out_of_ink_symbol: TextureRect
@export var jammed_symbol: TextureRect

@export var audio_player: AudioStreamPlayer3D


var status: Status
var printing_queue: Array[Document]
var position_offset_for_new_document: Vector3 = Vector3(0.0, 0.001, 0.0)
#var printed_documents: Array[PhysicalDocument]
var printing_time: float = 1.0
@export var printing_audio_streams: Array[AudioStream]

var is_out_of_paper: bool
var base_paper_per_document: int = 1
var paper_amount_stored: int
var paper_amount_capacity: int = 500
var paper_percentage: float:
	get:
		return float(paper_amount_stored) / float(paper_amount_capacity)
var paper_refilling_time: float = 3.0
@export var out_of_paper_audio_streams: Array[AudioStream]

var is_out_of_ink: bool
var base_ink_amount_per_document: float = 1.0
var ink_amount_stored: float
var ink_amount_capacity: float = 100.0
var ink_percentage: float:
	get:
		return ink_amount_stored / ink_amount_capacity
var ink_refilling_time: float = 3.0
@export var out_of_ink_audio_streams: Array[AudioStream]

var is_jammed: bool
var prints_since_last_jam: int
var jamming_base_probability: float = 0.001
var repairing_time: float = 3.0
@export var jammed_audio_streams: Array[AudioStream]

var is_tray_full: bool:
	get:
		return printer_tray.get_child_count() >= tray_capacity
var tray_capacity: int = 100
@export var tray_full_audio_streams: Array[AudioStream]


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()
	ink_amount_stored = ink_amount_capacity
	ink_progress_bar.max_value = ink_amount_capacity


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var documents_count: int = printing_queue.size()
	document_count_label.text = "%s" % documents_count
	if documents_count == 0 and not is_out_of_ink and not is_jammed and status == Status.IDLE:
		screen.shaded = true
	else:
		screen.shaded = false
	
	if is_out_of_ink:
		out_of_ink_symbol.modulate.a = 1.0
	else:
		out_of_ink_symbol.modulate.a = 0.0
	
	if is_jammed:
		jammed_symbol.modulate.a = 1.0
	else:
		jammed_symbol.modulate.a = 0.0
	
	ink_progress_bar.value = ink_amount_stored
	var style_box: StyleBoxFlat = (ink_progress_bar.get_theme_stylebox("fill") as StyleBoxFlat)
	if ink_percentage < 0.2:
		style_box.bg_color = Color.RED
	elif ink_percentage < 0.5:
		style_box.bg_color = Color.ORANGE
	else:
		style_box.bg_color = Color.WHITE
	
	try_printing_next_document()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func interact(node: Node) -> void:
	if is_jammed:
		repair(node)
		return
	if is_out_of_ink:
		refill_ink(node)
		return
	#pick_up_documents(node)


#func pick_up_documents(node: Node) -> void:
	#if printed_documents.size() == 0:
		#ActionLogger.create_log("NO_DOCUMENTS_TO_PICK_UP", true)
		#return
	#
	#var inventory: Inventory = UtilityTools.get_child_of_type(node, Inventory)
	#if inventory == null:
		#print("No inventory found.")
		#return
	#
	#for physical_document: PhysicalDocument in printed_documents:
		#inventory.add_item(physical_document)
		#remove_child(physical_document)
	#
	#ActionLogger.create_log(tr("PICKED_UP_DOCUMENTS").format({"amount":printed_documents.size()}))
	#printed_documents.clear()


func add_document_to_queue(document: Document) -> void:
	printing_queue.append(document)


func try_printing_next_document() -> void:
	if status != Status.IDLE:
		return
	if printing_queue.size() == 0:
		return
	if is_out_of_ink:
		return
	if is_jammed:
		return
	if is_tray_full:
		return
	
	print_next_document()


func print_next_document() -> void:
	if check_jamming():
		return
	
	status = Status.PRINTING
	play_printing_sound()
	
	var document: Document = printing_queue.pop_front()
	var physical_document: PhysicalDocument = (document_scene.instantiate() as PhysicalDocument).with_data(document)
	
	var offset: Vector3 = position_offset_for_new_document * printer_tray.get_child_count()
	printer_tray.add_child(physical_document)
	physical_document.position = document_spawn_position.position
	physical_document.rotation.x = deg_to_rad(-90)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(new_position: Vector3) -> void: physical_document.position = new_position, document_spawn_position.position, document_target_position.position + offset, printing_time)
	await tween.finished
	#printed_documents.append(physical_document)
	
	check_ink()
	check_tray()
	status = Status.IDLE


func play_printing_sound() -> void:
	audio_player.stream = printing_audio_streams.pick_random()
	play_sound()


func play_out_of_ink_sound() -> void:
	audio_player.stream = out_of_ink_audio_streams.pick_random()
	play_sound()


func play_jammed_sound() -> void:
	audio_player.stream = jammed_audio_streams.pick_random()
	play_sound()


func play_tray_full_sound() -> void:
	audio_player.stream = tray_full_audio_streams.pick_random()
	play_sound()


func play_sound() -> void:
	audio_player.pitch_scale = randf_range(0.90, 1.10)
	audio_player.play()


func check_ink() -> bool:
	ink_amount_stored -= (base_ink_amount_per_document * GameManager.difficulty)
	is_out_of_ink = ink_amount_stored < (base_ink_amount_per_document * GameManager.difficulty)
	if is_out_of_ink:
		play_out_of_ink_sound()
		ActionLogger.create_log("PRINTER_OUT_OF_INK")
	return is_out_of_ink


func check_jamming() -> bool:
	is_jammed = randf() < (jamming_base_probability * prints_since_last_jam * GameManager.difficulty)
	if is_jammed:
		play_jammed_sound()
		ActionLogger.create_log("PRINTER_JAMMED")
	else:
		prints_since_last_jam += 1
	return is_jammed


func check_tray() -> bool:
	#is_tray_full = printer_tray.get_child_count() >= tray_capacity
	if is_tray_full:
		play_tray_full_sound()
		ActionLogger.create_log("PRINTER_TRAY_FULL")
	return is_tray_full


func refill_ink(node: Node) -> void:
	if status != Status.IDLE:
		return
	
	status = Status.SERVICING
	
	var player: Player = node as Player
	if player != null:
		player.immobilize()
	
	var tween: Tween = create_tween()
	tween.tween_method(func(amount: float) -> void: ink_amount_stored = amount, ink_amount_stored, ink_amount_capacity, ink_refilling_time)
	await tween.finished
	is_out_of_ink = false
	
	player.unimmobilize()
	status = Status.IDLE


func repair(node: Node) -> void:
	if status != Status.IDLE:
		return
	if not is_jammed:
		return
	
	status = Status.SERVICING
	
	var player: Player = node as Player
	if player != null:
		player.immobilize()
	
	await get_tree().create_timer(repairing_time).timeout
	is_jammed = false
	prints_since_last_jam = 0
	
	player.unimmobilize()
	status = Status.IDLE
