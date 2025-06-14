class_name CoffeeMachine
extends Node3D


enum Status {
	IDLE,
	WORKING,
	SERVICING,
}


@export var audio_player: AudioStreamPlayer3D

var serviceable: Serviceable
var status: Status

var making_coffee_time: float = 4.3
@export var affected_states: Dictionary[State, float]
@export var making_coffee_audio_streams: Array[AudioStream]

@export var supplies: Array[SupplyData]

@export var particles: GPUParticles3D


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()
	register_serviceable()
	
	for supply_data: SupplyData in supplies:
		supply_data.amount_stored = supply_data.supply.amount_capacity
	particles.amount_ratio = 0.0

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
	
	for supply_data: SupplyData in supplies:
		if supply_data.is_out_of_supply:
			refill_supply(supply_data, node)
			return
	
	if status == Status.IDLE:
		make_coffee(node)


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


func make_coffee(node: Node) -> void:
	status = Status.WORKING
	particles.amount_ratio = 1.0
	play_making_coffee_sound()
	
	await get_tree().create_timer(making_coffee_time).timeout
	var human: Human = node as Human
	if human != null:
		for state_data: StateData in human.person.states:
			if affected_states.has(state_data.state):
				state_data.change_value(affected_states[state_data.state])
		
	
		ActionLogger.create_log("Ahhh...")
	
	check_supplies()
	particles.amount_ratio = 0.0
	status = Status.IDLE


func play_making_coffee_sound() -> void:
	audio_player.stream = making_coffee_audio_streams.pick_random()
	play_sound(false)


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
