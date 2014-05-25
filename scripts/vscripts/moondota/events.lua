--[[
	Events Core
]]--

MoonEvents = {}
MoonEvents.Events = 
{
	"OnPlayerConnectFull",
	"OnLastHit",
	"OnDotaUnitEvent"		
}

MoonEvents.Listeners = {}

local classtable = 
{
	eventname = "",

	constructor = function(self, eventname, wrapevent) 
		self.eventname = eventname

		if wrapevent then self:WrapGameEvent(wrapevent) end
	end
}

Event = class(classtable, {}, nil)
Event.eventname = "OnBaseEvent"

for _,event in pairs(MoonEvents.Events) do 
	MoonEvents.Listeners[event] = {}
end

function MoonEvents:Subscribe(listener)
	for key,value in pairs(listener) do
		if MUtil:TableHasValue(MoonEvents.Events, key) then
			table.insert(MoonEvents.Listeners[key], value)
		end
	end
end

function Event:WrapGameEvent(event)
	ListenToGameEvent(event, self.OnWrappedFired, self)
end

function Event:Fire(...)
	local listeners = MoonEvents.Listeners[self.eventname] 
	for _,listener in pairs(listeners) do 
		listener(...)
	end
end



--[[
	Events Definitions
]]--

EventLastHitDef = class(classtable,{},Event)

function EventLastHitDef:OnWrappedFired(keys)
	self:Fire(self, keys.cvarvalue, keys.cvarname) --due to varargs insanity you have to pad the call with 1 arg in the front...........
end

EventLastHit = EventLastHitDef("OnLastHit", "server_cvar")


EventPlayerConnectFullDef = class(classtable,{},Event)

function EventPlayerConnectFullDef:OnWrappedFired(keys)
	self:Fire(0, EntIndexToHScript(keys.index + 1))
end

EventPlayerConnectFull = EventPlayerConnectFullDef("OnPlayerConnectFull", "player_connect_full")



require("moondota/userdata/userevents") -- for implementing own events without changing the core lib file
