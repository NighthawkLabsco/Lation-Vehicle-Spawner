Config = {}

-- Command to open the vehicle spawner menu
Config.CommandName = 'vs'

-- Menu position: 'top-left', 'top-right', 'offcenter-left', 'offcenter-right'
Config.MenuPosition = 'top-right'

-- Vehicles marked as out of service (disabled)
Config.DisabledVehicles = {
    'policeb',
    'police2'
}

-- Vehicle categories with their vehicles
-- Format: [spawncode] = 'Display Name'
Config.Categories = {
    ['FP: Frontline Policing'] = {
        icon = 'fas fa-car-side',
        iconColor = '#3B82F6',
        vehicles = {
            ['police'] = 'Police Cruiser',
            ['police2'] = 'Police Buffalo',
            ['police3'] = 'Police Interceptor',
            ['police4'] = 'Police Unmarked',
            ['policeb'] = 'Police Bike',
            ['policet'] = 'Police Transport'
        }
    },
    ['Traffic Units'] = {
        icon = 'fas fa-traffic-light',
        iconColor = '#EF4444',
        vehicles = {
            ['policeold1'] = 'Traffic Sedan',
            ['policeold2'] = 'Traffic SUV',
            ['policet'] = 'Traffic Transport'
        }
    },
    ['Armed Response'] = {
        icon = 'fas fa-shield-alt',
        iconColor = '#10B981',
        vehicles = {
            ['riot'] = 'Riot Van',
            ['riot2'] = 'Riot Truck',
            ['policet'] = 'Armed Transport'
        }
    },
    ['Air Support'] = {
        icon = 'fas fa-helicopter',
        iconColor = '#F59E0B',
        vehicles = {
            ['polmav'] = 'Police Maverick',
            ['polmav2'] = 'Police Heli 2'
        }
    },
    ['Marine Unit'] = {
        icon = 'fas fa-ship',
        iconColor = '#06B6D4',
        vehicles = {
            ['predator'] = 'Police Predator',
            ['seashark'] = 'Police Seashark'
        }
    },
    ['Emergency Medical'] = {
        icon = 'fas fa-ambulance',
        iconColor = '#EC4899',
        vehicles = {
            ['ambulance'] = 'Ambulance'
        }
    },
    ['Fire & Rescue'] = {
        icon = 'fas fa-fire-extinguisher',
        iconColor = '#DC2626',
        vehicles = {
            ['firetruk'] = 'Fire Truck'
        }
    }
}

-- Spawn settings
Config.SpawnInVehicle = true -- Should player be placed inside vehicle after spawn
Config.SpawnEngineOn = true -- Should engine be running on spawn
Config.DeleteOldVehicle = true -- Delete player's current vehicle before spawning new one
Config.VehiclePlateText = 'VS' -- Plate prefix for spawned vehicles

-- Permission system (set to false to allow everyone to use)
Config.UsePermissions = false
Config.AllowedGroups = {
    'admin',
    'police',
    'ambulance'
}
