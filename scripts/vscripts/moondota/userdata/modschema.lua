PlayerLumberSchema = {
	Total = 1000	
}

PlayerTechSchema = {
	TechBuildings = {
		None = true
	}
}

PlayerIntentSchema = {
	WantsToBuild = "npc_trollsandelves_rock_1"
}

CollectorSchema = {
	DrainRate = 5,
	Tree = nil
}

TreeSchema = {
	Workers = 0,
	Remaining = 1000
}

BuildingSchema = {
	Queue = {},
	MaxHealth = 100,
	CurrentHealth = 1,
	TimeSpent = 0,
	Type = "configname",
	Finished = false,
	PlayerOwner = nil
}

BuilderSchema = {
	Buildings = {},
	HealthPercentPerTick = 0.01,
	MostRecent = nil
}

MData:AddSchema("PlayerTech", PlayerTechSchema)
MData:AddSchema("PlayerIntent", PlayerIntentSchema)
MData:AddSchema("Collector", CollectorSchema)
MData:AddSchema("Tree", TreeSchema)
MData:AddSchema("PlayerLumber", PlayerLumberSchema)
MData:AddSchema("Building", BuildingSchema)
MData:AddSchema("Builder", BuilderSchema)