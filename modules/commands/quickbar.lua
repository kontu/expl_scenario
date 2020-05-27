--[[-- Commands Module - Quickbar
    - Adds a command that allows players to load Quickbar presets
    @commands Quickbar
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
local config = require 'config.preset_player_quickbar' --- @dep config.preset_player_quickbar

--- Loads your quickbar preset
-- @command load-quickbar
Commands.new_command('load-quickbar', 'Loads your preset Quickbar items')
:add_alias('load-toolbar')
:register(function(player)
    if config[player.name] then
        local custom_quickbar = config[player.name]
        for i, item_name in pairs(custom_quickbar) do
          if item_name ~= nil and item_name ~= '' then
              player.set_quick_bar_slot(i, item_name)
          end
        end
    else
        Commands.error('Quickbar preset not found')
    end
end)

--- Saves your quickbar preset to the script-output folder
-- @command save-quickbar
Commands.new_command('save-quickbar', 'Saves your Quickbar preset items to file')
:add_alias('save-toolbar')
:register(function(player)
    local quickbar_names = {}
    for i=1, 100 do
        local slot = player.get_quick_bar_slot(i)
        if slot ~= nil then
            quickbar_names[i] = slot.name
        end
    end
    game.write_file("quickbar_preset.txt", player.name .. " = " .. serpent.line(quickbar_names) .. "\n", true)
    Commands.print("Quickbar saved")
end)