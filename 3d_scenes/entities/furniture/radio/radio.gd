extends StaticBody3D


@export var audio_player: AudioStreamPlayer3D
@export var particles: GPUParticles3D


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	toggle()


func toggle() -> void:
	audio_player.playing = not audio_player.playing
	particles.emitting = audio_player.playing
