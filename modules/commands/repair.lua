local Commands = require 'expcore.commands'
local config = require 'config.repair'
require 'config.command_parse_general'

local max_time_to_live = 4294967295 -- unit32 max
Commands.new_command('repair','Repairs entities on your force around you')
:add_param('range',false,'integer-range',1,config.max_range)
:register(function(player,range,raw)
    local revive_count = 0
    local heal_count = 0
    local range2 = range^2
    local surface = player.surface
    local center = player.position
    local area = {{x=center.x-range,y=center.y-range},{x=center.x+range,y=center.y+range}}
    if config.allow_ghost_revive then
        local ghosts = surface.find_entities_filtered({area=area,type='entity-ghost',force=player.force})
        for _,ghost in pairs(ghosts) do
            if ghost.valid then
                local x = ghost.position.x-center.x
                local y = ghost.position.y-center.y
                if x^2+y^2 <= range2 then
                    if config.allow_blueprint_repair or ghost.time_to_live ~= max_time_to_live then
                        revive_count = revive_count+1
                        if not config.disallow[ghost.ghost_name] then ghost.revive() end
                    end
                end
            end
        end
    end
    if config.allow_heal_entities then
        local entities = surface.find_entities_filtered({area=area,force=player.force})
        for _,entity in pairs(entities) do
            if entity.valid then
                local x = entity.position.x-center.x
                local y = entity.position.y-center.y
                if entity.health and entity.get_health_ratio() ~= 1 and x^2+y^2 <= range2 then
                    heal_count = heal_count+1
                    entity.health = max_time_to_live
                end
            end
        end
    end
    return Commands.success{'exp-commands.repair-result',revive_count,heal_count}
end)