class_name TimeEvent
extends Resource


var time: int
var observer: Object
var event: Event


func with_data(time_to_assign: int, observer_to_assign: Object, event_to_assign: Event = null) -> TimeEvent:
	self.time = time_to_assign
	self.observer = observer_to_assign
	self.event = event_to_assign
	assert(observer != null and observer.has_method("notify"), str(observer.get_script().resource_path) + " is creating TimeEvent, but has no \"notify\" method to receive TimeEvent!")
	
	return self

## Notifies the observer, supplying self as a parameter. Observer has to have the following function to receive the notification
## [codeblock]
## func notify(time_event: TimeEvent) -> void:
## 	pass
## [/codeblock]
func notify_observer() -> void:
	observer.call("notify", self)
