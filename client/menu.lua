local currentMenu = nil

-- Check if vehicle is disabled
local function isVehicleDisabled(spawncode)
    for _, disabled in ipairs(Config.DisabledVehicles) do
        if disabled == spawncode then
            return true
        end
    end
    return false
end

-- Create vehicle option
local function createVehicleOption(spawncode, displayName, categoryName)
    local disabled = isVehicleDisabled(spawncode)
    
    return {
        title = displayName,
        description = disabled and '**Out of Service**' or 'Click to spawn this vehicle',
        icon = disabled and 'fas fa-lock' or 'fas fa-car',
        iconColor = disabled and '#EF4444' or '#10B981',
        disabled = disabled,
        metadata = {
            { label = 'Spawn Code', value = spawncode },
            { label = 'Category', value = categoryName },
            { label = 'Status', value = disabled and 'Out of Service' or 'Available' }
        },
        onSelect = function()
            if not disabled then
                TriggerEvent('vehiclespawner:client:spawnVehicle', spawncode)
            end
        end
    }
end

-- Create category menu
local function createCategoryMenu(categoryName, categoryData)
    local menuId = 'vs_category_' .. categoryName:gsub('%s+', '_'):lower()
    local options = {}
    
    -- Add all vehicles in this category
    for spawncode, displayName in pairs(categoryData.vehicles) do
        table.insert(options, createVehicleOption(spawncode, displayName, categoryName))
    end
    
    -- Sort options alphabetically
    table.sort(options, function(a, b)
        return a.title < b.title
    end)
    
    exports.lation_ui:registerMenu({
        id = menuId,
        title = categoryName,
        subtitle = 'Select a vehicle to spawn',
        menu = 'vs_main',
        position = Config.MenuPosition,
        canClose = true,
        options = options
    })
    
    return menuId
end

-- Create main menu
local function createMainMenu()
    local options = {}
    
    -- Create category options
    for categoryName, categoryData in pairs(Config.Categories) do
        local submenuId = createCategoryMenu(categoryName, categoryData)
        
        -- Count available vehicles
        local totalVehicles = 0
        local availableVehicles = 0
        for spawncode, _ in pairs(categoryData.vehicles) do
            totalVehicles = totalVehicles + 1
            if not isVehicleDisabled(spawncode) then
                availableVehicles = availableVehicles + 1
            end
        end
        
        table.insert(options, {
            title = categoryName,
            description = string.format('**%d** available vehicles', availableVehicles),
            icon = categoryData.icon or 'fas fa-folder',
            iconColor = categoryData.iconColor or '#71717A',
            menu = submenuId,
            arrow = true,
            metadata = {
                { label = 'Total Vehicles', value = tostring(totalVehicles) },
                { label = 'Available', value = tostring(availableVehicles) },
                { label = 'Out of Service', value = tostring(totalVehicles - availableVehicles) }
            }
        })
    end
    
    -- Sort categories alphabetically
    table.sort(options, function(a, b)
        return a.title < b.title
    end)
    
    -- Add close option
    table.insert(options, {
        title = 'Close Menu',
        description = 'Exit the vehicle spawner',
        icon = 'fas fa-times-circle',
        iconColor = '#EF4444',
        onSelect = function()
            exports.lation_ui:hideMenu()
        end
    })
    
    exports.lation_ui:registerMenu({
        id = 'vs_main',
        title = 'Vehicle Spawner',
        subtitle = 'Select a category',
        position = Config.MenuPosition,
        canClose = true,
        options = options
    })
end

-- Show main menu
function ShowVehicleSpawner()
    if currentMenu then
        exports.lation_ui:hideMenu()
        currentMenu = nil
        return
    end
    
    exports.lation_ui:showMenu('vs_main')
    currentMenu = 'vs_main'
end

-- Initialize menus
CreateThread(function()
    Wait(1000) -- Wait for lation_ui to load
    createMainMenu()
end)

-- Export for other resources
exports('ShowVehicleSpawner', ShowVehicleSpawner)
