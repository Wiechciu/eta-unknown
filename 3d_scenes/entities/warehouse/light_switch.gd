extends StaticBody3D


@export var light: Light3D


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = GlobalDebugger.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	toggle()


func toggle() -> void:
	if light.light_energy == 0.0:
		light.light_energy = 1.0
	else:
		light.light_energy = 0.0
