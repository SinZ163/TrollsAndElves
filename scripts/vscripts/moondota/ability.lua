abilityclasstable = 
{
	constructor = function(self) 
	end
}

MoonAbility = class(abilityclasstable, {}, nil)
MoonAbility.Data = {}
MoonAbility.Subscribers = {}

MoonAbility.Modifiers = {}

MoonAbility.Schema = {
	Var = 1.0
}

MoonAbility.Wrapped = {}

function MoonAbility:WrapEntity(varname, entity)
	--local wrapped = self.Wrapped[entity]
	local desiredSchema = self:WrapRules(varname, entity)
	if desiredSchema ~= "" then 
		return MData:For(desiredSchema, entity)
	end
end

function MoonAbility:SchemaFor(entity)
	return self.Schema[entity:GetClassname()]
end

function MoonAbility:EventProxy(event, keys)
--	DeepPrintTable(keys)
	local chest = self:WrapKeys(keys)
	self[event](self, chest)
end

function MoonAbility:NewEntity(schema)

end

function MoonAbility:WrapKeys(keys)
	local ret = {}
	for k,v in pairs(keys) do
		if k == "target_entities" and v then --doesnt work good yet
			print("Wrapping ent array..")
			ret[v] = {}
			for _,arrayent in pairs(v) do table.insert(ret[v], self:WrapEntity("target_entities", arrayent)) end
		end
		if type(v) == "table" and v.GetClassname then -- is this an ent
			local wrapped = self:WrapEntity(k, v)
			if wrapped then ret[k] = wrapped else ret[k] = v end
		else ret[k] = v
		end
	end
	return ret
end