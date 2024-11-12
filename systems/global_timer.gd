extends Node


@export var timer: int
@export var minute: int:
	get:
		return (timer) % 60
@export var hour: int:
	get:
		return (timer / 60) % 24
@export var day: int:
	get:
		return (timer / (60 * 24)) % 30
@export var week: int:
	get:
		return (timer / (60 * 24 * 7)) % 52
@export var month: int:
	get:
		return (timer / (60 * 24  * 30)) % 12
@export var year: int:
	get:
		return timer / (60 * 24  * 365)

func _on_timer_timeout() -> void:
	timer += 1
