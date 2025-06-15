## TODO: add simple on/off tween for symbols when out of ink or jammed
## TODO: add some visual and sound indication for both servicing 
## FIXME: supply visuals (like ink) to be modular

class_name Printer
extends ComputerInterface


enum Status {
	IDLE,
	WORKING,
	SERVICING,
}

@export var printer_tray: Node3D
@export var document_spawn_position: Node3D
@export var document_target_position: Node3D
@export var document_scene: PackedScene
@export var print_type: Document.PrintType

@export var screen: Sprite3D
@export var document_count_label: Label
@export var ink_progress_bar: ProgressBar
@export var out_of_ink_symbol: TextureRect
@export var jammed_symbol: TextureRect

@export var audio_player: AudioStreamPlayer3D

var serviceable: Serviceable


var status: Status
var printing_queue: Array[Document]
var position_offset_for_new_document: Vector3 = Vector3(0.0, 0.001, 0.0)
#var printed_documents: Array[PhysicalDocument]
var printing_time: float = 1.0
@export var printing_audio_streams: Array[AudioStream]

@export var supplies: Array[SupplyData]
var is_out_of_any_supply: bool:
	get:
		for supply_data: SupplyData in supplies:
			if supply_data.is_out_of_supply:
				return true
		return false
var ink_supply: SupplyData

var is_jammed: bool
var prints_since_last_jam: int
var jamming_base_probability: float = 0.001
var repairing_time: float = 3.0
@export var jammed_audio_streams: Array[AudioStream]
@export var repairing_audio_streams: Array[AudioStream]

var is_tray_full: bool:
	get:
		return printer_tray.get_child_count() >= tray_capacity
var tray_capacity: int = 100
@export var tray_full_audio_streams: Array[AudioStream]


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()
	register_serviceable()
	
	for supply_data: SupplyData in supplies:
		supply_data.amount_stored = supply_data.supply.amount_capacity
		
		#FIXME to be modular
		if supply_data.supply.supply_name == "INK":
			ink_supply = supply_data
			ink_progress_bar.max_value = supply_data.supply.amount_capacity


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var documents_count: int = printing_queue.size()
	document_count_label.text = "%s" % documents_count
	if documents_count == 0 and not is_out_of_any_supply and status == Status.IDLE:
		screen.shaded = true
	else:
		screen.shaded = false
	
	if ink_supply.is_out_of_supply:
		out_of_ink_symbol.modulate.a = 1.0
	else:
		out_of_ink_symbol.modulate.a = 0.0
	
	if is_jammed:
		jammed_symbol.modulate.a = 1.0
	else:
		jammed_symbol.modulate.a = 0.0
	
	ink_progress_bar.value = ink_supply.amount_stored
	var style_box: StyleBoxFlat = (ink_progress_bar.get_theme_stylebox("fill") as StyleBoxFlat)
	if ink_supply.amount_percentage < 0.2:
		style_box.bg_color = Color.RED
	elif ink_supply.amount_percentage < 0.5:
		style_box.bg_color = Color.ORANGE
	else:
		style_box.bg_color = Color.WHITE
	
	try_printing_next_document()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


func register_serviceable() -> void:
	serviceable = UtilityTools.get_child_of_type(self, Serviceable) as Serviceable


func interact(node: Node) -> void:
	if status != Status.IDLE:
		ActionLogger.create_log("INTERACT_BUSY")
		return
	
	if is_jammed:
		repair(node)
		return
	
	for supply_data: SupplyData in supplies:
		if supply_data.is_out_of_supply:
			refill_supply(supply_data, node)
			return
	
	ActionLogger.create_log("INTERACT_NOTHING")


func add_document_to_queue(document: Document) -> void:
	printing_queue.append(document)


func try_printing_next_document() -> void:
	if status != Status.IDLE:
		return
	if printing_queue.size() == 0:
		return
	if is_out_of_any_supply:
		return
	if is_jammed:
		return
	if is_tray_full:
		return
	
	print_next_document()


func print_next_document() -> void:
	if check_jamming():
		return
	
	status = Status.WORKING
	play_printing_sound()
	
	var document: Document = printing_queue.pop_front()
	var printed_document: Node3D
	match print_type:
		Document.PrintType.DOCUMENT:
			printed_document = (document_scene.instantiate() as PhysicalDocument).with_data(document)
		Document.PrintType.LABEL:
			printed_document = (document_scene.instantiate() as PhysicalLabel).with_data(document)
	
	var offset: Vector3 = position_offset_for_new_document * printer_tray.get_child_count()
	printer_tray.add_child(printed_document)
	printed_document.position = document_spawn_position.position
	printed_document.rotation.x = deg_to_rad(-90)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(func(new_position: Vector3) -> void: printed_document.position = new_position, document_spawn_position.position, document_target_position.position + offset, printing_time)
	await tween.finished
	
	check_supplies()
	check_tray()
	status = Status.IDLE


func play_printing_sound() -> void:
	audio_player.stream = printing_audio_streams.pick_random()
	play_sound()


func play_jammed_sound() -> void:
	audio_player.stream = jammed_audio_streams.pick_random()
	play_sound()


func play_tray_full_sound() -> void:
	audio_player.stream = tray_full_audio_streams.pick_random()
	play_sound()


func play_out_of_supply_sound(supply_data: SupplyData) -> void:
	audio_player.stream = supply_data.supply.out_of_supply_streams.pick_random()
	play_sound()


func play_sound(with_pitch_variable: bool = true) -> void:
	if with_pitch_variable:
		audio_player.pitch_scale = randf_range(0.90, 1.10)
	else:
		audio_player.pitch_scale = 1.0
	audio_player.play()


func check_supplies() -> void:
	for supply_data: SupplyData in supplies:
		
		supply_data.amount_stored -= (supply_data.supply.amount_per_use * GameManager.difficulty)
		if supply_data.is_out_of_supply:
			play_out_of_supply_sound(supply_data)
			ActionLogger.create_log(tr("OUT_OF_SUPPLY").format({"supply_name": tr(supply_data.supply.supply_name)}))


func check_jamming() -> bool:
	is_jammed = randf() < (jamming_base_probability * prints_since_last_jam * GameManager.difficulty)
	if is_jammed:
		play_jammed_sound()
		ActionLogger.create_log("PRINTER_JAMMED")
	else:
		prints_since_last_jam += 1
	return is_jammed


func check_tray() -> bool:
	if is_tray_full:
		play_tray_full_sound()
		ActionLogger.create_log("PRINTER_TRAY_FULL")
	return is_tray_full


func refill_supply(supply_data: SupplyData, node: Node) -> void:
	status = Status.SERVICING
	serviceable.start_service(supply_data.supply.refilling_time, supply_data.supply.refilling_supply_streams.pick_random())
	
	var player: Player = node as Player
	if player != null:
		player.immobilize()
	
	var tween: Tween = create_tween()
	tween.tween_method(func(amount: float) -> void: supply_data.amount_stored = amount, supply_data.amount_stored, supply_data.supply.amount_capacity, supply_data.supply.refilling_time)
	await tween.finished
	
	player.unimmobilize()
	status = Status.IDLE


func repair(node: Node) -> void:
	if not is_jammed:
		return
	
	status = Status.SERVICING
	serviceable.start_service(repairing_time, repairing_audio_streams.pick_random())
	
	var player: Player = node as Player
	if player != null:
		player.immobilize()
	
	await get_tree().create_timer(repairing_time).timeout
	is_jammed = false
	prints_since_last_jam = 0
	
	player.unimmobilize()
	status = Status.IDLE
