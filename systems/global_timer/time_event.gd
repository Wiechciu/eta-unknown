class_name TimeEvent
extends Resource


var time: int
var observer: Object
var args: Array


@warning_ignore("shadowed_variable")
static func create_new(time: int, observer: Object, ...args: Array) -> TimeEvent:
	var new_time_event: TimeEvent = TimeEvent.new()
	new_time_event.time = time
	new_time_event.observer = observer
	new_time_event.args = args
	assert(observer != null and observer.has_method("notify"), str(observer.get_script().resource_path) + " is creating TimeEvent, but has no \"notify\" method to receive TimeEvent!")
	
	return new_time_event

## Notifies the observer, supplying self as a parameter. Observer has to have the following function to receive the notification
## [codeblock]
## func notify(time_event: TimeEvent) -> void:
## 	pass
## [/codeblock]
func notify_observer() -> void:
	observer.call("notify", self)
