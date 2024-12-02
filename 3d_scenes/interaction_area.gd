class_name InteractionArea
extends Area3D


var interactable_bodies: Array[Node3D]


func _on_body_entered(body: Node3D) -> void:
	if body is not Player and body.has_method("interact"):
		interactable_bodies.append(body)
		print("In range of %s to interact." % body.name)


func _on_body_exited(body: Node3D) -> void:
	if interactable_bodies.has(body):
		interactable_bodies.erase(body)
