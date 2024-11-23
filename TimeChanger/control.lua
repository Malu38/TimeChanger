local debug_status = nil
local debug_mod_name = "time-changer"
local debug_file = debug_mod_name .. "-debug.txt"
require("utils")

local function init_globals()
        storage.speed_mem = storage.speed_mem or settings.global["max-time-speed"].value
end

local function on_init()
        debug_print("on_init")
        init_globals()
end

script.on_init(on_init)

--------------------------------------------------------------------------------------

local function on_configuration_changed(data)
        if data.mod_changes ~= nil then
                local changes = data.mod_changes[debug_mod_name]
                if changes ~= nil then
                        debug_print("update mod: ", debug_mod_name, " ", tostring(changes.old_version), " to ", tostring(changes.new_version))

                        init_globals()
                end
        end
end

script.on_configuration_changed(on_configuration_changed)

--------------------------------------------------------------------------------------

local function on_gui_click(event)
        local player = game.players[event.player_index]
        if string.match(event.element.name, "timechanger_") == nil then
                return
        end
        if player.admin then
                local min_time_speed = 1 / settings.global["min-time-speed"]
                local max_time_speed = settings.global["max-time-speed"]
                if event.element.name == "timechanger_but_slowest" then
                        if game.speed ~= min_time_speed then game.speed = min_time_speed end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_slower" then
                        if game.speed > min_time_speed then game.speed = game.speed / 2 end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_speed" then
                        if game.speed == 1 then game.speed = storage.speed_mem else game.speed = 1 end
                elseif event.element.name == "timechanger_but_faster" then
                        if game.speed < max_time_speed then game.speed = game.speed * 2 end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_faster" then
                        if game.speed ~= max_time_speed then game.speed = max_time_speed end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                end

                update_guis()
        else
                player.print({"mod-messages.timechanger-message-admins-only"})
        end
end

script.on_event(defines.events.on_gui_click, on_gui_click)

--------------------------------------------------------------------------------------

function build_gui(player)
        local gui1 = player.gui.top.timechanger_flow

        if gui1 == nil and storage.display then
                debug_print("create frame player " .. player.name)
                gui1 = player.gui.top.add({type = "flow", name = "timechanger_flow", direction = "horizontal", styles = "timechanger_flow_style"})
                gui1.add({type = "button", name = "timechanger_but_slowest", caption = "<<", font_color = colors.lightred, style = "timechanger_button_style"})
                gui1.add({type = "button", name = "timechanger_but_slower", caption = "<", font_color = colors.lightred, style = "timechanger_button_style"})
                gui1.add({type = "button", name = "timechanger_but_speed", caption = "x1", font_color = colors.green, style = "timechanger_button_style"})
                gui1.add({type = "button", name = "timechanger_but_faster", caption = ">", font_color = colors.lightred, style = "timechanger_button_style"})
                gui1.add({type = "button", name = "timechanger_but_fastest", caption = ">>", font_color = colors.lightred, style = "timechanger_button_style"})
        end
        return gui1
end

--------------------------------------------------------------------------------------

function update_guis()
        if storage.display then
                for _, player in pairs(game.players) do
                        if player.connected then
                                local flow = build_gui(player)
                                local s

                                if game.speed == 1 then
                                        flow.timechanger_but_speed.caption = "x1"
                                elseif game.speed < 1 then
                                        s = string.format("/%1.0f", 1/game.speed)
                                        flow.timechanger_but_speed.caption = s
                                elseif game.speed < 1 then
                                        s = string.format("x%1.0f", game.speed)
                                        flow.timechanger_but_speed.caption = s
                                end
                        end
                end
        end
end

--------------------------------------------------------------------------------------

local interface = {}

function interface.reset()
        debug_print("reset")
        for _, player in pairs(game.players) do
                if player.gui.top.timechanger_flow then
                        player.gui.top.timechanger_flow.destroy()
                end
        end

        update_guis()
end

function interface.setspeed(speed)
        debug_print("set time")
        if speed == nil then speed = 1 end
	speed = math.floor(speed)
        if speed < 1 then speed = 1 end
        if speed > settings.global["max-time-speed"].value then
                speed = settings.global["max-time-speed"].value
        end
        storage.speed = speed
        update_guis()
end

function interface.off()
        debug_print("off")

        storage.display = false

        for _, player in pairs(game.players) do
                if player.connected and player.gui.top.timechanger_flow then player.gui.top.timechanger_flow.destroy() end
        end
end

function interface.on()
        debug_print("on")
        
        storage.display = true

        update_guis()
end

remote.add_interface("timechanger", interface)