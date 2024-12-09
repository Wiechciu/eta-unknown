extends StaticBody3D


@export var audio_player: AudioStreamPlayer3D
@export var particles: GPUParticles3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	for child: Node in get_children():
		var interactable: Interactable = child as Interactable
		if interactable != null:
			interactable.interacted.connect(interact)


func interact() -> void:
	toggle()


func toggle() -> void:
	audio_player.playing = not audio_player.playing
	particles.emitting = audio_player.playing
