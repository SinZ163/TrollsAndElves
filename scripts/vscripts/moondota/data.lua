MData = {}
MData.Schema = {}

function MData:AddSchema(schemaname, data)
	self.Schema[schemaname] = {
		Default = data,
		Entries = {}
	}
end


function MData:For(schemaname, ent)
	local ret = self.Schema[schemaname].Entries[ent] or self:Assign(schemaname, ent)
	return ret
end

function MData:Assign(schemaname, entobj)
	local data = self.Schema[schemaname].Default
	local bind = TableCopy(data)
	bind.Ent = entobj
	self.Schema[schemaname].Entries[entobj] = bind
	return self.Schema[schemaname].Entries[entobj] --better way?
end

function TableCopy(table)
	local ret = {}
	for k,v in pairs(table) do 
		ret[k] = v
	end
	return ret
end

require("moondota/userdata/modschema")