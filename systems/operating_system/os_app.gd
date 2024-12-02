class_name OsApp
extends Control


signal closed(app: OsApp)


func close() -> void:
	closed.emit(self)
