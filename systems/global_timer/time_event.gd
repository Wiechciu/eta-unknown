class_name TimeEvent
extends Resource


var time: int
var observer: Object
var event: Event


func with_data(time: int, observer: Object, event: Event = null) -> TimeEvent:
	self.time = time
	self.observer = observer
	self.event = event
	assert(observer != null and observer.has_method("notify"), str(observer.get_script().resource_path) + " is creating TimeEvent, but has no \"notify\" method to receive TimeEvent!")
	
	return self


func notify() -> void:
	observer.call("notify")
