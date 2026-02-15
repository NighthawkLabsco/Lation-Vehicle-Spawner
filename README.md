# Vehicle Spawner - Modern UI Edition

A fully modernized FiveM vehicle spawner script using the **Lation Modern UI** framework. This is a complete rewrite of the original London Studios Vehicle Spawner, converted from C# to Lua with a sleek, contemporary interface.
## ✨ Features

- 🎨 **Modern UI Integration** - Built with Lation Modern UI for a clean, professional interface
- 📁 **Category System** - Organize vehicles into customizable categories
- 🔒 **Out of Service System** - Mark vehicles as unavailable/disabled
- 🎯 **Smart Spawning** - Automatically finds clear spawn locations
- 🚗 **Vehicle Management** - Delete old vehicle before spawning new one
- 🔑 **Permission System** - Optional permission checks with framework integration
- 📊 **Metadata Display** - Shows vehicle status, category info, and availability
- 🎨 **Customizable Icons** - FontAwesome icons with custom colors per category
- 🔧 **Admin Commands** - Enable/disable vehicles on the fly
- 📝 **Logging Support** - Optional Discord webhook integration

## 📋 Requirements

- [lation_ui] - **REQUIRED**
- FiveM server (recommended build 2802 or higher)
- Basic knowledge of Lua scripting

## 🚀 Installation

1. **Install Dependencies**
   - Download and install lation_ui
   - Ensure `lation_ui` is started **before** this resource

2. **Download & Extract**
   - Download this resource
   - Extract to your server's `resources` folder
   - Rename folder to `vehiclespawner` (or your preferred name)

3. **Configure**
   - Edit `config.lua` to customize:
     - Command name
     - Vehicle categories
     - Disabled vehicles
     - Spawn settings
     - Permission system

4. **Add to server.cfg**
   ```cfg
   ensure lation_ui
   ensure vehiclespawner
   ```

5. **Restart Server**
   - Restart your server or use `refresh` and `ensure vehiclespawner`

## ⚙️ Configuration

### Basic Settings

```lua
Config.CommandName = 'vs'  -- Command to open menu
Config.MenuPosition = 'top-right'  -- Menu position on screen
```

### Menu Positions

Choose from: `'top-left'`, `'top-right'`, `'offcenter-left'`, `'offcenter-right'`

### Disabled Vehicles

```lua
Config.DisabledVehicles = {
    'policeb',
    'police2'
}
```

### Adding Categories

```lua
Config.Categories = {
    ['Category Name'] = {
        icon = 'fas fa-car-side',  -- FontAwesome icon
        iconColor = '#3B82F6',     -- Hex color code
        vehicles = {
            ['spawncode'] = 'Display Name',
            ['police'] = 'Police Cruiser',
            ['police2'] = 'Police Buffalo'
        }
    }
}
```

### Spawn Settings

```lua
Config.SpawnInVehicle = true    -- Place player inside vehicle
Config.SpawnEngineOn = true     -- Start engine automatically
Config.DeleteOldVehicle = true  -- Delete current vehicle first
Config.VehiclePlateText = 'VS'  -- Plate text prefix
```

### Permission System

```lua
Config.UsePermissions = false   -- Enable/disable permissions
Config.AllowedGroups = {
    'admin',
    'police',
    'ambulance'
}
```

## 🎮 Usage

### In-Game Commands

- **`/vs`** (or your configured command) - Open the vehicle spawner menu
- **`/vsdisable [vehicle]`** - Disable a vehicle (admin only)
- **`/vsenable [vehicle]`** - Enable a vehicle (admin only)

### Default Keybind

- **F5** - Open vehicle spawner (can be rebound in GTA settings)

### Menu Navigation

1. Open the menu with `/vs` or F5
2. Select a category from the main menu
3. Choose a vehicle from the category
4. Vehicle spawns in front of you

## 🔧 Advanced Features

### Framework Integration

The script includes commented examples for:
- **ESX** integration
- **QBCore** integration
- Custom framework integration

Edit `client/main.lua` and `server/main.lua` to integrate with your framework's permission system.

### Discord Logging

To enable Discord webhook logging:

1. Open `server/main.lua`
2. Find the `SendToDiscord` function
3. Add your webhook URL:
   ```lua
   local webhookURL = 'YOUR_DISCORD_WEBHOOK_URL_HERE'
   ```

### Custom Metadata

You can customize the metadata shown when hovering over vehicles by editing the `createVehicleOption` function in `client/menu.lua`:

```lua
metadata = {
    { label = 'Spawn Code', value = spawncode },
    { label = 'Category', value = categoryName },
    { label = 'Status', value = disabled and 'Out of Service' or 'Available' },
    { label = 'Custom Field', value = 'Custom Value' }
}
```

## 🎨 Icon Reference

This resource uses FontAwesome icons. Some useful icons for categories:

- `fas fa-car-side` - Standard vehicles
- `fas fa-truck` - Trucks/SUVs
- `fas fa-motorcycle` - Motorcycles
- `fas fa-helicopter` - Aircraft
- `fas fa-ship` - Boats
- `fas fa-ambulance` - Medical
- `fas fa-fire-extinguisher` - Fire
- `fas fa-shield-alt` - Police/Security
- `fas fa-tools` - Utility vehicles

Browse all icons at: [FontAwesome Icons](https://fontawesome.com/icons)

## 📝 ACE Permissions

Add these to your `server.cfg` for permission control:

```cfg
# Admin permissions
add_ace group.admin vehiclespawner.admin allow

# Group permissions
add_ace group.police vehiclespawner.police allow
add_ace group.ambulance vehiclespawner.ambulance allow
```

## 🐛 Troubleshooting

### Menu won't open
- Ensure `lation_ui` is installed and started first
- Check F8 console for errors
- Verify command name in config matches what you're typing

### Vehicles not spawning
- Check vehicle spawn codes are valid
- Ensure you're not in a restricted area
- Try increasing spawn distance in `client/main.lua`

### Permission issues
- If using framework permissions, check your integration code
- Verify ACE permissions in `server.cfg`
- Set `Config.UsePermissions = false` to disable permissions

## 📜 Credits

- **Original Script**: London Studios (C# version)
- **Modern UI Framework**: [Lation Scripts](https://lationscripts.com/)
- **Modernization**: This Lua conversion with Lation UI integration

## 📄 License

This is a modernized version of the original London Studios Vehicle Spawner. Please respect the original license terms while using this resource.

## 🆘 Support

For issues related to:
- **Lation Modern UI**: Visit [Lation Scripts Discord](https://discord.gg/9EbY4nM5uu)
- **This Resource**: Create an issue on the repository

## 🔄 Changelog

### Version 2.0.0
- Complete rewrite in Lua
- Integration with Lation Modern UI
- Added category system with icons
- Added metadata display
- Improved spawn logic
- Added admin commands
- Permission system integration
- Framework compatibility

---

**Enjoy your modern vehicle spawner! 🚗✨**
