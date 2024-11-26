local debug_mod_name = "time-changer"
require("utils")

local enemies = {}

local function init_globals()
        storage.refresh_speed = storage.refresh_speed or settings.startup["timechanger-default-padlock"].value == "unlock"
        storage.speed_mem = storage.speed_mem or settings.global["timechanger-max-game-speed"].value
end

local function init_player(player)
        if player.connected then
                build_gui(player)
        end
end

local function init_players()
        for _, player in pairs(game.players) do
                init_player(player)
        end
end

function on_init()
        init_globals()
        init_players()
end

script.on_init(on_init)

function on_configuration_changed(data)
        if data.mod_changes ~= nil then
                local changes = data.mod_changes[debug_mod_name]
                if changes ~= nil then
                        init_globals()

                        init_players()

                        update_guis()
                end
        end
end

script.on_configuration_changed(on_configuration_changed)

function on_player_created(event)
        local player = game.players[event.player_index]

        init_player(player)
end

script.on_event(defines.events.on_player_created, on_player_created)

local function on_player_joined_game(event)
	local player = game.players[event.player_index]
	
	init_player(player)
end

script.on_event(defines.events.on_player_joined_game, on_player_joined_game )

local function on_entity_damaged(event)
        if storage.refresh_speed then
                if event.cause.force.name == "enemy" then
                        local speed = 1 / settings.global["timechanger-speed-when-damaged"].value
                        if game.speed ~= speed then
                                game.speed = speed
                                update_guis()
                        end
                end
        end
end

script.on_event(defines.events.on_entity_damaged, on_entity_damaged)

local function on_entity_spawned(event)
        entity = event.entity
        table.insert(enemies, entity)
end
script.on_event(defines.events.on_entity_spawned, on_entity_spawned)

function on_gui_click(event)
        local player = game.players[event.player_index]
        if string.match(event.element.name, "timechanger_") == nil then
                return
        end
        if player.admin then
                local min_time_speed = 1 / settings.global["timechanger-min-game-speed"].value
                local max_time_speed = settings.global["timechanger-max-game-speed"].value
                if event.element.name == "timechanger_but_slowest" then
                        if game.speed > min_time_speed then game.speed = min_time_speed end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_slower" then
                        if game.speed > min_time_speed then game.speed = game.speed / 2 end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_speed" then
                        if game.speed == 1 then game.speed = storage.speed_mem else game.speed = 1 end
                elseif event.element.name == "timechanger_but_faster" then
                        if game.speed < max_time_speed then game.speed = game.speed * 2 end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_fastest" then
                        if game.speed < max_time_speed then game.speed = max_time_speed end
                        if game.speed ~= 1 then storage.speed_mem = game.speed end
                elseif event.element.name == "timechanger_but_lock" then
                        storage.refresh_speed = not storage.refresh_speed
                end
                update_guis()
        end
end

script.on_event(defines.events.on_gui_click, on_gui_click)

function build_gui(player)
        local gui1 = player.gui.top.timechanger_flow
        if gui1 == nil then
                gui1 = player.gui.top.add({type="flow", name="timechanger_flow", direction="horizontal", style="timechanger_flow_style"})
                gui1.add({type="button", name="timechanger_but_slowest", caption="<<", style="timechanger_button_style", font_color=colors.red})
                gui1.add({type="button", name="timechanger_but_slower", caption="<", style="timechanger_button_style", font_color=colors.red})
                gui1.add({type="button", name="timechanger_but_speed", caption="x1", style="timechanger_button_style", font_color=colors.green})
                gui1.add({type="button", name="timechanger_but_faster", caption=">", style="timechanger_button_style", font_color=colors.red})
                gui1.add({type="button", name="timechanger_but_fastest", caption=">>", style="timechanger_button_style", font_color=colors.red})
                gui2 = gui1.add({type="sprite-button", name="timechanger_but_lock", style="timechanger_sprite_style"})
                if storage.refresh_speed then
                        gui2.sprite = "sprite_timechanger_lock_open"
                else
                        gui2.sprite = "sprite_timechanger_lock_closed"
                end
        end
        return(gui1)
end

function update_guis()
        for _, player in pairs(game.players) do
                if player.connected then
                        local flow = build_gui(player)
                        local s
                        local p

                        if game.speed == 1 then
                                flow.timechanger_but_speed.caption = "x1"
                        elseif game.speed < 1 then
                                s = string.format("/%1.0f", 1/game.speed)
                                flow.timechanger_but_speed.caption = s
                        elseif game.speed > 1 then
                                s = string.format("x%1.0f", game.speed)
                                flow.timechanger_but_speed.caption = s
                        end

                        if storage.refresh_speed then
                                flow.timechanger_but_lock.sprite = "sprite_timechanger_lock_open"
                        else
                                flow.timechanger_but_lock.sprite = "sprite_timechanger_lock_closed"
                        end
                       
                end
        end
end