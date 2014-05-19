
--[[
	Timers Core
]]--

MoonTimers = {}

local timers = {}

function MoonTimers:AddTimer(interval, timesToRepeat, callback, context)
	local timerconfig = {
		Callback = callback,
		Interval = interval,
		TimesToRepeat = timesToRepeat,
		LastRepeat = GameRules:GetGameTime(),
		TimesRepeated = 0,
		Context = context
	}

	timers[timerconfig] = timerconfig --is this goodd??

	return timerconfig
end

function MoonTimers:RemoveTimer(timer)
	timers[timer] = nil --is this goodd??
end

function TimerThink(dt)
	local now = GameRules:GetGameTime()

	for _,config in pairs(timers) do
		if now >= config.LastRepeat + config.Interval then 
			config.Callback(config.Context)
			config.TimesRepeated = config.TimesRepeated + 1
			config.LastRepeat = now
		end
		if config.TimesToRepeat > 0 and config.TimesToRepeat <= config.TimesRepeated then
			MoonTimers:RemoveTimer(config) -- safe?
		end
	end

	return 0.1
end

Entities:First():SetContextThink("TimerThink", TimerThink, 0.10) --whatup

--[[
	Timers Util
]]--
