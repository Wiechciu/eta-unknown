class_name TimeEvent
extends Resource


var time: int
var observer: Object


func notify() -> void:
	if observer != null and observer.has_method("notify"):
		observer.notify(self)
	else:
		push_error(str((observer.get_script() as Script).resource_path) + " is creating TimeEvent, but has no \"notify\" method to receive TimeEvent!")
