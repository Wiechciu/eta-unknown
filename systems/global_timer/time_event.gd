class_name TimeEvent
extends Resource


var time: int
var observer: Object
var event: Event


@warning_ignore("shadowed_variable")
func with_data(time: int, observer: Object, event: Event = null) -> TimeEvent:
	self.time = time
	self.observer = observer
	self.event = event
	assert(observer != null and observer.has_method("notify"), str(observer.get_script().resource_path) + " is creating TimeEvent, but has no \"notify\" method to receive TimeEvent!")
	
	return self

## Notifies the observer, supplying self as a parameter. Observer has to have the following function to receive the notification
## [codeblock]
## func notify(time_event: TimeEvent) -> void:
## 	pass
## [/codeblock]
func notify_observer() -> void:
	observer.call("notify", self)
