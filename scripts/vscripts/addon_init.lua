print('\n\nLoading TrollsAndElves modules...')

--function Dynamic_Wrap( mt, name )
--    if Convars:GetFloat( 'developer' ) == 1 then
--        local function w(...) return mt[name](...) end
--        return w
--    else
--        return mt[name]
--    end
--end

-- Module loading system (it reports errors)
local totalErrors = 0
local function loadModule(name)
    local status, err = pcall(function()
        -- Load the module
        require(name)
    end)

    if not status then
        -- Add to the total errors
        totalErrors = totalErrors+1

        -- Tell the user about it
        print('WARNING: '..name..' failed to load!')
        print(err)
    end
end

-- Load Frota
loadModule('lib.json')         -- Json Library
loadModule('TrollsAndElves')        -- Main program

if totalErrors == 0 then
    -- No loading issues
    print('Loaded TrollsAndElves modules successfully!\n')
elseif totalErrors == 1 then
    -- One loading error
    print('1 TrollsAndElves module failed to load!\n')
else
    -- More than one loading error
    print(totalErrors..' TrollsAndElves modules failed to load!\n')
end