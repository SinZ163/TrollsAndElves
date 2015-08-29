local UnitNameInit = {
	
}

local ClassnameInit = {
	player = {
		WantsToBuild = "npc_trollsandelves_rock_1",
		LumberTotal = 1000,
		TechBuildings = { None = true }
	}
}

local TypeInit = {
	Builder = {
		Buildings = {}
	}
}

EntityInit = {}

function EntityInit:NewByType(handle, type)
	TablePaste(TypeInit[type], handle) 
end

function EntityInit:NewByUnit(handle, unitname)
	TablePaste(UnitNameInit[unitname], handle) 
end

function EntityInit:NewByClassname(handle, classname)
	TablePaste(ClassnameInit[classname], handle) 
end

function TablePaste(table, handle)
	if table then
		for k,v in pairs(table) do
			handle[k] = v
		end
	end
end