extends StaticBody3D


const MIN_ENERGY: float = 0.0
const MAX_ENERGY: float = 1.0

@export var light: Light3D
@export var emission_bodies: Array[MeshInstance3D]


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
	toggle_light()
	toggle_emissions()


func toggle_light() -> void:
	if light.light_energy == MIN_ENERGY:
		light.light_energy = MAX_ENERGY
	else:
		light.light_energy = MIN_ENERGY


func toggle_emissions() -> void:
	for body: MeshInstance3D in emission_bodies:
		if body.mesh != null and body.mesh is PrimitiveMesh:
			var primitive_mesh: PrimitiveMesh = body.mesh as PrimitiveMesh
			if primitive_mesh.material != null and primitive_mesh.material is BaseMaterial3D:
				var material: BaseMaterial3D = primitive_mesh.material as BaseMaterial3D
				material.emission_enabled = not material.emission_enabled
