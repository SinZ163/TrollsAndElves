PlayerLumberSchema = {
	Total = 1000	
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
	Time = 5,
	TimeSpent = 0
}

BuilderSchema = {
	Buildings = {},
	MostRecent = nil
}



MData:AddSchema("Collector", CollectorSchema)
MData:AddSchema("Tree", TreeSchema)
MData:AddSchema("PlayerLumber", PlayerLumberSchema)
MData:AddSchema("Building", BuildingSchema)
MData:AddSchema("Builder", BuilderSchema)