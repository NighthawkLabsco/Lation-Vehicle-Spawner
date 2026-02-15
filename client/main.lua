local spawnedVehicles = {}

-- Get forward position from player
local function GetForwardPosition(distance)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local x = coords.x + math.sin(math.rad(-heading)) * distance
    local y = coords.y + math.cos(math.rad(-heading)) * distance
    
    return vector4(x, y, coords.z, heading)
end

-- Check if spawn position is clear
local function IsSpawnPointClear(coords, radius)
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        local vehCoords = GetEntityCoords(vehicle)
        local distance = #(coords.xy - vehCoords.xy)
        
        if distance < radius then
            return false
        end
    end
    
    return true
end

-- Delete player's current vehicle
local function DeleteCurrentVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end

-- Spawn vehicle
local function SpawnVehicle(model)
    local modelHash = GetHashKey(model)
    
    -- Request model
    if not IsModelInCdimage(modelHash) then
        exports.lation_ui:notify({
            title = 'Vehicle Spawner',
            description = 'Invalid vehicle model: ' .. model,
            type = 'error',
            duration = 5000
        })
        return
    end
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end
    
    -- Find spawn position
    local spawnPos = GetForwardPosition(5.0)
    local attempts = 0
    
    while not IsSpawnPointClear(vector3(spawnPos.x, spawnPos.y, spawnPos.z), 3.0) and attempts < 10 do
        spawnPos = GetForwardPosition(5.0 + (attempts * 2))
        attempts = attempts + 1
    end
    
    if attempts >= 10 then
        exports.lation_ui:notify({
            title = 'Vehicle Spawner',
            description = 'No clear spawn location found',
            type = 'error',
            duration = 5000
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end
    
    -- Delete old vehicle if configured
    if Config.DeleteOldVehicle then
        DeleteCurrentVehicle()
    end
    
    -- Get ground Z coordinate
    local groundZ = spawnPos.z
    local found, z = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 100.0, false)
    if found then
        groundZ = z
    end
    
    -- Create vehicle
    local vehicle = CreateVehicle(modelHash, spawnPos.x, spawnPos.y, groundZ, spawnPos.w, true, false)
    
    if vehicle == 0 then
        exports.lation_ui:notify({
            title = 'Vehicle Spawner',
            description = 'Failed to spawn vehicle',
            type = 'error',
            duration = 5000
        })
        SetModelAsNoLongerNeeded(modelHash)
        return
    end
    
    -- Set vehicle properties
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    
    -- Set plate text
    SetVehicleNumberPlateText(vehicle, Config.VehiclePlateText)
    
    -- Set engine state
    if Config.SpawnEngineOn then
        SetVehicleEngineOn(vehicle, true, true, false)
    end
    
    -- Place player in vehicle
    if Config.SpawnInVehicle then
        local ped = PlayerPedId()
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
    end
    
    -- Track spawned vehicle
    table.insert(spawnedVehicles, vehicle)
    
    -- Notify success
    exports.lation_ui:notify({
        title = 'Vehicle Spawner',
        description = 'Vehicle spawned successfully',
        type = 'success',
        duration = 3000
    })
    
    -- Clean up
    SetModelAsNoLongerNeeded(modelHash)
end

-- Register spawn vehicle event
RegisterNetEvent('vehiclespawner:client:spawnVehicle', function(model)
    SpawnVehicle(model)
end)

-- Check permissions
local function CheckPermissions()
    if not Config.UsePermissions then
        return true
    end
    
    -- Framework integration examples:
    
    -- ESX Example:
    -- local ESX = exports['es_extended']:getSharedObject()
    -- local xPlayer = ESX.GetPlayerData()
    -- for _, group in ipairs(Config.AllowedGroups) do
    --     if xPlayer.job.name == group then
    --         return true
    --     end
    -- end
    -- return false
    
    -- QBCore Example:
    -- local QBCore = exports['qb-core']:GetCoreObject()
    -- local PlayerData = QBCore.Functions.GetPlayerData()
    -- for _, group in ipairs(Config.AllowedGroups) do
    --     if PlayerData.job.name == group then
    --         return true
    --     end
    -- end
    -- return false
    
    -- For now, return true (implement your framework check here)
    return true
end

-- Register command
RegisterCommand(Config.CommandName, function()
    if not CheckPermissions() then
        exports.lation_ui:notify({
            title = 'Vehicle Spawner',
            description = 'You do not have permission to use this',
            type = 'error',
            duration = 5000
        })
        return
    end
    
    ShowVehicleSpawner()
end, false)

-- Key mapping (F5 by default, can be changed in GTA settings)
RegisterKeyMapping(Config.CommandName, 'Open Vehicle Spawner', 'keyboard', 'F5')

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Delete all spawned vehicles
    for _, vehicle in ipairs(spawnedVehicles) do
        if DoesEntityExist(vehicle) then
            DeleteVehicle(vehicle)
        end
    end
end)
