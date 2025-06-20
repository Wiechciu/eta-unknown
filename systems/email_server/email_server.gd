extends Node


signal email_registered(email: Email)

@export var emails: Array[Email]
const REPLY_SUBJECT_PREFIX: String = "RE: "
const LINE_BREAK: String = "\n"
const EMAIL_SEPARATOR: String = "______________________________"
const EMAIL_SUBJECTS: Array[String] = [
	"Shipment Delayed: New ETA Inside",
	"Important: Customs Documentation Update",
	"Weekly Logistics Performance Report",
	"New Carrier Rates Effective This Month",
	"Urgent: Freight Booking Confirmation Needed",
	"Port Congestion: Impact on Delivery Schedules",
	"New Warehouse Location Now Operational",
	"Reminder: Submit Packing List by EOD",
	"Q3 Supply Chain KPIs Released",
	"Action Required: Missing HS Codes",
	"Updated Incoterms Guidelines",
	"Reminder: Schedule Your Pickup Today",
	"Delivery Exception – Client Notification Sent",
	"Freight Invoice Attached – Please Review",
	"New Compliance Regulations in Effect",
	"Tracking Information for Order #8472",
	"Driver Assigned for Tomorrow’s Pickup",
	"POD (Proof of Delivery) Now Available",
	"Inventory Reconciliation Required",
	"Export Control Audit: Prep Checklist",
	"New 3PL Partnership Announcement",
	"Upcoming Warehouse Maintenance Downtime",
	"RFQ Submission Deadline Approaching",
	"Final Mile Carrier Change Notification",
	"Container Rolled Over – Next Vessel Info",
	"Monthly Logistics Newsletter – June Edition",
	"Dangerous Goods Certification Needed",
	"Book Your Spot: Logistics Strategy Webinar",
	"New Packaging Requirements from Supplier",
	"System Downtime Scheduled This Weekend",
	"Sailing Schedule Update – Asia-Europe Route",
	"Spot Quote Available for LTL Shipment",
	"Driver ETA Changed – Live Tracking Update",
	"Import Clearance Delay at Port",
	"Update: Shipment Transferred to Rail",
	"New Integration: TMS and WMS Sync Live",
	"Warehouse Inventory Levels Critical",
	"Annual Carrier Review – Your Feedback Needed",
	"Fuel Surcharge Increase Notification",
	"Backorder Fulfillment Expected This Week",
	"Client Return Shipment Request Received",
	"Hazmat Documentation Checklist",
	"Onboarding New Freight Forwarders",
	"Last-Mile Metrics Dashboard Launched",
	"Holiday Shipping Deadlines Reminder",
	"Packaging Compliance Audit Findings",
	"Supply Chain Risk Alert – Weather Advisory",
	"Proof of Export for Your Records",
	"New SLA Agreements Signed – Review Inside",
	"Time-Sensitive: Verify Shipment Dimensions",
	"Invitation: Global Logistics Summit 2025"
]
const EMAIL_SUBJECTS_RFQ: Array[String] = [
	"New Spot Request – Quotation Needed",
	"RFQ: Immediate Transport Quote Required",
	"Spot Shipment – Request for Quotation",
	"Urgent: Freight Quote Request",
	"Quick Quote Needed – Transport Request",
	"Request for Spot Quote – Logistics",
	"Spot RFQ: Pricing Request for Shipment",
	"Need a Transport Quote – Spot Request",
	"Freight Quote Needed – One-time Shipment",
	"Transport Cost Request – Immediate",
	"Quote Request: Ad-hoc Shipment",
	"Spot RFQ: Short-Term Transport Requirement",
	"Request for Quotation – One-off Shipment",
	"Looking for Rates – Spot Freight",
	"Quick RFQ: Logistics Quote Needed ASAP",
	"RFQ – Spot Shipment Pricing Needed",
	"Immediate Quotation Request – Freight",
	"One-Time Transport Request – Please Quote",
	"Quote Needed: Spot Logistics Service",
	"Freight Pricing Request – Spot Move",
	"New Shipment – Requesting Quotation",
	"Urgent Spot Quote Required – Please Respond",
	"Transport RFQ – Quick Turnaround Needed",
	"Request for Freight Quote – Single Shipment",
	"Spot RFQ – Short-Notice Shipment",
	"Quotation Request for Time-Sensitive Shipment",
	"Request for Spot Freight Estimate",
	"Logistics Spot Quote Needed – Action Required",
	"Ad-hoc Freight Quote Request",
	"Quote Required for Immediate Shipment",
	"RFQ – Domestic Spot Transport Needed",
	"Request for Quotation – Non-Recurring Shipment",
	"Freight Quote Request – One-Time Move",
	"Spot Quote Needed for Upcoming Shipment",
	"Please Quote: Spot Logistics Requirement",
	"Instant Quote Request – Freight",
	"Request for Transport Pricing – Ad-hoc",
	"New RFQ – Spot Cargo Movement",
	"Quick Pricing Request – Freight Inquiry",
	"One-Time Shipment – RFQ Attached",
	"Requesting Spot Pricing for Logistics Service",
	"Need a Quick Quote – Spot Transport",
	"Immediate RFQ – Shipment Details Inside",
	"Pricing Request for Freight – Spot Service",
	"Looking for Spot Quote – Transport Required",
	"Transport Quote Request – Urgent Spot Move",
	"New Logistics RFQ – Immediate Response Needed",
	"Spot Shipment Quotation Request",
	"Urgent Request: Spot Logistics Quotation",
	"One-Off Shipment – Pricing Inquiry"
]
const EMAIL_SUBJECTS_SPO: Array[String] = [
	"New Shipment Order – Please Confirm",
	"Transport Order Attached – Action Required",
	"Shipment Details for Execution",
	"New Booking – Transport Instructions Enclosed",
	"Please Arrange Shipment – Order Info Inside",
	"Shipment Order – Pickup Required",
	"Transport Request – Order Confirmation Needed",
	"New Freight Order – Schedule as Soon as Possible",
	"Shipment Confirmation Request",
	"New Order: Arrange Transport",
	"Order to Ship – Please Acknowledge",
	"Urgent Shipment Order – Same Day Pickup",
	"Freight Order Enclosed – Request for Execution",
	"New Logistics Order – Details Attached",
	"Request to Arrange Shipment – New Order",
	"Shipment Order – Time-Critical Delivery",
	"Transport Booking Request – Immediate Action",
	"One-Time Shipment – Please Process Order",
	"Shipping Order – Please Confirm Availability",
	"Transport Job – Instructions Inside",
	"Order for Cargo Movement – Please Arrange",
	"Shipment Arrangement Required – Order Info",
	"New Shipping Instruction – Execute Shipment",
	"Transport Order for Upcoming Shipment",
	"Order to Move Cargo – Details Attached",
	"Freight Movement Order – Your Action Needed",
	"Time-Sensitive Shipment – Order Confirmation Needed",
	"Booking Request – Please Schedule Shipment",
	"Order to Ship – Quick Turnaround Needed",
	"Transport Order – One-Off Job",
	"Delivery Order – Pickup Required",
	"New Shipment to Arrange – Order Enclosed",
	"Cargo Ready for Pickup – Shipping Order Inside",
	"Freight Order – Please Arrange Pickup",
	"Logistics Execution Request – Shipment Order",
	"Please Arrange Spot Shipment – Order Attached",
	"Order for Freight Service – Confirm Dispatch",
	"Cargo Dispatch Request – Immediate Transport",
	"Pickup Order – Confirm Scheduling",
	"New Load to Transport – Order Details Inside",
	"Transport Service Required – Shipment Order",
	"Spot Shipment – Booking Details Enclosed",
	"New Instruction to Ship – Please Confirm",
	"Order to Execute One-Time Shipment",
	"Order for Urgent Cargo Dispatch",
	"New Job: Freight to Be Shipped",
	"Shipment Order – Requested Transit Date Inside",
	"Please Confirm: Shipment Order for Today",
	"Cargo Movement Order – Ready to Go",
	"One-Off Shipment Order – Please Review"
]


func _ready() -> void:
	if GameManager.player == null:
		await GameManager.player_assigned
	
	for email: Email in emails:
		email.date = GlobalTimer.now
		email.from = GlobalRefs.people.filter(func(person: Person) -> bool: return person != GameManager.player.person).pick_random()
		email.to = GameManager.player.person


func register_email(email: Email) -> void:
	emails.append(email)
	email_registered.emit(email)
	
	if email.from == GameManager.player.person:
		schedule_response(email)


func schedule_response(original_email: Email) -> void:
	var response_delay_min: float = 2.0
	var response_delay_max: float = 10.0
	await get_tree().create_timer(randf_range(response_delay_min, response_delay_max)).timeout
	
	var message: String = "Hello," \
		+ LINE_BREAK + "Well noted, thank you!"
	
	var new_email: Email = Email.create_new(
		original_email.to,
		original_email.from,
		REPLY_SUBJECT_PREFIX + original_email.subject,
		add_message_and_footer_to_beginning(message, original_email.body, original_email.to),
		GlobalTimer.now,
		[],
		original_email
	)
	register_email(new_email)


func add_message_and_footer_to_beginning(message: String, body: String, person: Person) -> String:
	return message \
	+ add_footer_and_separator_to_beginning(body, person)


func add_footer_and_separator_to_beginning(body: String, person: Person) -> String:
	return get_footer(person) \
	+ LINE_BREAK + EMAIL_SEPARATOR \
	+ LINE_BREAK + body


func get_footer(person: Person) -> String:
	return LINE_BREAK \
	+ LINE_BREAK + "[i]" + "Best regards," \
	+ LINE_BREAK + person.full_name \
	+ LINE_BREAK + person.job_position.title \
	+ LINE_BREAK + person.email \
	+ LINE_BREAK + person.phone_number \
	+ LINE_BREAK + person.employer.print_string + "[/i]" 
