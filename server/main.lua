-- Server-side logging and permission validation

local function Log(message)
    print('^3[Vehicle Spawner]^7 ' .. message)
end

-- Check if player has permission (framework integration example)
local function HasPermission(source)
    if not Config.UsePermissions then
        return true
    end
    
    -- Example for ESX
    -- local xPlayer = ESX.GetPlayerFromId(source)
    -- if xPlayer then
    --     return xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance'
    -- end
    
    -- Example for QBCore
    -- local Player = QBCore.Functions.GetPlayer(source)
    -- if Player then
    --     return Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance'
    -- end
    
    -- Default: check ace permissions
    for _, group in ipairs(Config.AllowedGroups) do
        if IsPlayerAceAllowed(source, 'vehiclespawner.' .. group) then
            return true
        end
    end
    
    return false
end

-- Vehicle spawn logging
RegisterNetEvent('vehiclespawner:server:logSpawn', function(vehicleModel, vehicleNetId)
    local src = source
    local playerName = GetPlayerName(src)
    local identifiers = GetPlayerIdentifiers(src)
    
    Log(string.format('%s (ID: %d) spawned vehicle: %s (NetID: %s)', 
        playerName, src, vehicleModel, vehicleNetId))
end)

-- Permission check callback (can be called from client if needed)
RegisterNetEvent('vehiclespawner:server:checkPermission', function()
    local src = source
    TriggerClientEvent('vehiclespawner:client:permissionResult', src, HasPermission(src))
end)

-- Discord webhook logging (optional)
local function SendToDiscord(title, message, color)
    local webhookURL = '' -- Add your Discord webhook URL here
    
    if webhookURL == '' then return end
    
    local embed = {
        {
            ['title'] = title,
            ['description'] = message,
            ['color'] = color or 3447003,
            ['footer'] = {
                ['text'] = os.date('%Y-%m-%d %H:%M:%S')
            }
        }
    }
    
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', 
        json.encode({embeds = embed}), 
        {['Content-Type'] = 'application/json'}
    )
end

-- Admin commands
RegisterCommand('vsdisable', function(source, args)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'vehiclespawner.admin') then
        TriggerClientEvent('lation_ui:notify', source, {
            title = 'Vehicle Spawner',
            description = 'Insufficient permissions',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    if #args < 1 then
        TriggerClientEvent('lation_ui:notify', source, {
            title = 'Vehicle Spawner',
            description = 'Usage: /vsdisable [vehicle]',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    local vehicle = args[1]:lower()
    
    -- Check if already disabled
    for _, disabled in ipairs(Config.DisabledVehicles) do
        if disabled == vehicle then
            TriggerClientEvent('lation_ui:notify', source, {
                title = 'Vehicle Spawner',
                description = vehicle .. ' is already disabled',
                type = 'error',
                duration = 5000
            })
            return
        end
    end
    
    table.insert(Config.DisabledVehicles, vehicle)
    TriggerClientEvent('vehiclespawner:client:syncConfig', -1, Config)
    
    Log(string.format('Vehicle %s has been disabled', vehicle))
    TriggerClientEvent('lation_ui:notify', source, {
        title = 'Vehicle Spawner',
        description = vehicle .. ' has been disabled',
        type = 'success',
        duration = 5000
    })
end, true)

RegisterCommand('vsenable', function(source, args)
    if source ~= 0 and not IsPlayerAceAllowed(source, 'vehiclespawner.admin') then
        TriggerClientEvent('lation_ui:notify', source, {
            title = 'Vehicle Spawner',
            description = 'Insufficient permissions',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    if #args < 1 then
        TriggerClientEvent('lation_ui:notify', source, {
            title = 'Vehicle Spawner',
            description = 'Usage: /vsenable [vehicle]',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    local vehicle = args[1]:lower()
    
    -- Find and remove from disabled list
    for i, disabled in ipairs(Config.DisabledVehicles) do
        if disabled == vehicle then
            table.remove(Config.DisabledVehicles, i)
            TriggerClientEvent('vehiclespawner:client:syncConfig', -1, Config)
            
            Log(string.format('Vehicle %s has been enabled', vehicle))
            TriggerClientEvent('lation_ui:notify', source, {
                title = 'Vehicle Spawner',
                description = vehicle .. ' has been enabled',
                type = 'success',
                duration = 5000
            })
            return
        end
    end
    
    TriggerClientEvent('lation_ui:notify', source, {
        title = 'Vehicle Spawner',
        description = vehicle .. ' is not disabled',
        type = 'error',
        duration = 5000
    })
end, true)

-- Sync config to clients
RegisterNetEvent('vehiclespawner:server:requestConfig', function()
    TriggerClientEvent('vehiclespawner:client:syncConfig', source, Config)
end)

Log('Server initialized successfully')
