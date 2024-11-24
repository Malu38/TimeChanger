local debug_status = 1
local debug_mod_name = "time-changer"
local debug_file = debug_mod_name .. "-debug.txt"
require("utils")

local function init_globals()
        storage.speed_mem = storage.speed_mem or settings.global["timechanger-max-time-speed"]
end

local function init_player(player)
        if storage.ticks == nil then return end

        if player.connected then
                build_gui(player)
        end
end

local function init_players()
        for player in pairs(game.players) do
                init_player(player)
        end
end

function on_init()
        init_globals()
        init_players()
end

script.on_init(on_init)

function on_configuration_changed(data)
        init_globals()
        init_players()
end

script.on_configuration_changed(on_configuration_changed)

function on_load()
        init_globals()
        init_players()
end

script.on_load(on_load)

function on_gui_click(event)

end

script.on_event(defines.events.on_gui_click, on_gui_click)

function build_gui(player)
        local gui = player.gui.top
        if gui.timechanger_flow ~= nil then return end

        gui.add({type="flow", name="timechanger_flow", direction="horizontal", style="timechanger_flow"})
        gui.timechanger_flow.add({type="button", name="timechanger_but_slowest", caption="<<", font_color=colors.lightred, style="timechanger_button"})
        gui.timechanger_flow.add({type="button", name="timechanger_but_slower", caption="<", font_color=colors.lightred, style="timechanger_button"})
        gui.timechanger_flow.add({type="button", name="timechanger_but_speed", caption="x1", font_color=colors.green, style="timechanger_button"})
        gui.timechanger_flow.add({type="button", name="timechanger_but_faster", caption=">", font_color=colors.lightred, style="timechanger_button"})
        gui.timechanger_flow.add({type="button", name="timechanger_but_fastest", caption=">>", font_color=colors.lightred, style="timechanger_button"})
        gui.timechanger_flow.add({type="sprite-button", name="timechanger_but_lock", sprite="sprite_timechanger_lock_open", clicked_sprite="sprite_timechanger_lock_closed", style="timechanger_sprite_style"})
end