class_name PartyGenerator
extends Node


const PREFIXES: Array[String] = [
	"Global", "Prime", "Next", "Ultra", "Dynamic", "Rapid", "Pioneer", "Vertex", "Summit", "Nexus",
	"Quantum", "Apex", "Echo", "Iron", "Nova", "Atlas", "Vortex", "Pulse", "Fusion", "Crystal",
	"True", "Bright", "Deep", "Blue", "Green", "Solid", "Clear", "Open", "Swift", "Urban",
	"Golden", "Silver", "Royal", "Future", "Bold", "Stellar", "Gravity", "Arc", "Meta", "Core",
	"Omni", "Solar", "Lunar", "Zenith", "Neo", "Magna", "Alpha", "Beta", "Sigma", "Horizon",
	"Hyper", "Turbo", "Smart", "Echo", "Trans", "Opti", "Cyber", "Neon", "Iron", "Fire",
	"Digital", "Mono", "Hexa", "Tri", "One", "Infini", "Nova", "Epic", "Axial", "Proto",
	"Astro", "Nano", "Max", "Elevate", "Nimbus", "Velvet", "Spectra", "Drift", "North", "West",
	"Cobalt", "Amber", "Orchid", "Ivory", "Crimson", "Azure", "Chrome", "Zebra", "Oasis", "Frost",
	"Nimbus", "Zen", "Ironwood", "Truepoint", "Skyward", "Topline", "Vertexa", "Equinox", "Tranquil", "Silent",
	"Delta", "Strato", "Centra", "Arch", "Polaris", "Eon", "Beacon", "Lumen", "Corewave", "Frontline"
]
const BUZZWORDS: Array[String] = [
	"Solutions", "Systems", "Networks", "Technologies", "Concepts", "Industries", "Dynamics", "Ventures", "Enterprises", "Holdings",
	"Analytics", "Capital", "Strategies", "Group", "Logics", "Matrix", "Node", "Design", "Fabric", "Layer",
	"Circle", "Bridge", "Edge", "Chain", "Sphere", "Flow", "Source", "Point", "Works", "Path",
	"Labs", "Forge", "Spark", "Thread", "Nest", "Guild", "Union", "Platform", "Grid", "Stack",
	"Studio", "Verse", "Cloud", "Engine", "Factor", "Orbit", "Panel", "Frame", "Beacon", "Anchor",
	"Delta", "Core", "Crate", "Link", "Depot", "Realm", "Port", "Fleet", "Logic", "Task",
	"Dock", "Hub", "Hive", "Loop", "Layer", "Module", "Tier", "Unit", "Axis", "Point",
	"Chronicle", "Vault", "Mirror", "Portion", "Access", "Nucleus", "Vision", "Thread", "Merge", "Pulse",
	"Horizon", "Drift", "Wave", "Pilot", "Cell", "Drop", "Rise", "Stretch", "Play", "Cellar",
	"Engine", "Field", "Array", "Note", "Lab", "Solutioneers", "Roots", "Meadow", "Dockyard", "Cluster",
	"Storm", "Vector", "Branch", "Stack", "Frame", "Boost", "Drill", "Machine", "Line", "Beam",
	"Motion", "Linker", "Craft", "Sparkle", "Sprout", "Growth", "Vault", "Runner", "Map", "Pipeline"
]
const SUFFIXES: Array[String] = [
	"Inc", "LLC", "Corp", "Ltd", "Group", "Co", "PLC", "GmbH", "S.A.", "Partners",
	"Consulting", "Studios", "Collective", "Associates", "Consortium", "Works", "Agency", "Initiative", "Syndicate", "Authority",
	"Solutions", "Ventures", "Holdings", "Industries", "Enterprises", "Networks", "Systems", "Technologies", "Logistics", "Dynamics",
	"International", "Worldwide", "Global", "Union", "Federation", "Labs", "Node", "Core", "Outfit", "Engineers",
	"Machines", "Architects", "Creators", "Makers", "Builders", "Pioneers", "Minds", "Catalysts", "Executors", "Operators",
	"Council", "Commission", "Exchange", "Studio", "Haven", "Nest", "Vault", "Realm", "Deck", "Fellows",
	"Thinktank", "Conglomerate", "Sons", "Brothers", "Guild", "Club", "League", "Society", "Crüe", "Syndicate",
	"Associates", "Advisors", "Thinkers", "Shapers", "Navigators", "Mechanics", "Crafters", "Boosters", "Explorers", "Nexus",
	"People", "Collective", "Front", "Foundation", "Empire", "Network", "Stack", "Matrix", "Cloud", "Forge",
	"One", "360", "Plus", "Zero", "X", "Pro", "Max", "Edge", "Link", "Shift"
]
const MAX_ATTEMPTS: int = 1000


static func create_new() -> Party:
	var party_name: String = get_unique_name()
	
	var new_party: Party = Party.new().with_data(
		GlobalRefs.get_party_id(),
		randi_range(0, Party.Type.size() - 1), ##TODO: fix to make some it more diverse type by implementing probabilities. The same with person genders later with the probabilities
		party_name,
		"Street name", ##TODO: fix to generate actual addresses
		"1",
		"2",
		"12345",
		"City",
		GlobalRefs.countries.pick_random(),
		[] as Array[Person],
		0.0,
		[] as Array[RequestForQuotation],
		[] as Array[Shipment],
		100000,
		0.0,
		0.0,
		0.0,
		)
	
	if new_party.is_supplier:
		new_party.reliability_factor = randf_range(0.9, 1.0)
		new_party.cost_factor = randf_range(0.8, 1.0)	
	
	return new_party


static func get_unique_name() -> String:
	var full_name: String = ""
	var attempt_count: int = 0
	
	while attempt_count < MAX_ATTEMPTS:
		var prefix: String = PREFIXES.pick_random()
		var buzzword: String = BUZZWORDS.pick_random()
		var suffix: String = SUFFIXES.pick_random()
		
		# Avoid repeating elements like "Logistics Logistics Inc"
		if prefix.to_lower() == buzzword.to_lower() or \
			prefix.to_lower() == suffix.to_lower() or \
			buzzword.to_lower() == suffix.to_lower():
			attempt_count += 1
			continue
		
		full_name = "%s %s %s" % [prefix, buzzword, suffix]
		
		var name_is_unique: bool = true
		for party: Party in GlobalRefs.parties:
			if party.name == full_name:
				name_is_unique = false
				break
		
		if name_is_unique:
			return full_name
	
		attempt_count += 1
	
	# Fallback if all else fails
	return "Generic Company %d" % randi()
