extends StaticBody3D


@export var audio_player: AudioStreamPlayer3D
@export var particles: GPUParticles3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = GlobalDebugger.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact)


@warning_ignore("unused_parameter")
func interact(node: Node) -> void:
	toggle()


func toggle() -> void:
	audio_player.playing = not audio_player.playing
	particles.emitting = audio_player.playing
