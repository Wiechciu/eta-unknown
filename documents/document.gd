class_name Document
extends Control


static var documents: Array[Document]


func _init() -> void:
	documents.append(self)


func _exit_tree() -> void:
	documents.erase(self)
