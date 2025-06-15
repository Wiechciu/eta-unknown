@tool
extends StaticBody3D


const MIN_ENERGY: float = 0.0
const MAX_ENERGY: float = 1.0

@export var light: Light3D
@export var emission_bodies: Array[MeshInstance3D]
@export var is_on: bool:
	set(value):
		is_on = value
		
		if not is_node_ready():
			await ready
		toggle_light(is_on)
		toggle_emissions(is_on)


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	UtilityTools.assert_all_exported_properties(self)
	register_interactable()


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	is_on = not is_on


func toggle_light(on: bool) -> void:
	if on:
		light.light_energy = MAX_ENERGY
	else:
		light.light_energy = MIN_ENERGY


func toggle_emissions(on: bool) -> void:
	for body: MeshInstance3D in emission_bodies:
		if body.mesh != null and body.mesh is PrimitiveMesh:
			var primitive_mesh: PrimitiveMesh = body.mesh as PrimitiveMesh
			if primitive_mesh.material != null and primitive_mesh.material is BaseMaterial3D:
				var material: BaseMaterial3D = primitive_mesh.material as BaseMaterial3D
				material.emission_enabled = on
