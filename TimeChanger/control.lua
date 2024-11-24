local debug_status = 1
local debug_mod_name = "time-changer"
local debug_file = debug_mod_name .. "-debug.txt"
require("utils")

local function init_globals()
        storage.refresh_
        storage.speed_mem = storage.speed_mem or settings.global["timechanger-max-time-speed"]
end

local function init_player(player)
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
                end
                update_guis()
        end
end

script.on_event(defines.events.on_gui_click, on_gui_click)

function build_gui(player)
        local gui = player.gui.top.timechanger_flow
        if gui == nil then
                gui = player.gui.top.add({type="flow", name="timechanger_flow", direction="horizontal", style="timechanger_flow_style"})
                gui.add({type="button", name="timechanger_but_slowest", caption="<<", font_color=colors.lightred, style="timechanger_button_style"})
                gui.add({type="button", name="timechanger_but_slower", caption="<", font_color=colors.lightred, style="timechanger_button_style"})
                gui.add({type="button", name="timechanger_but_speed", caption="x1", font_color=colors.green, style="timechanger_button_style"})
                gui.add({type="button", name="timechanger_but_faster", caption=">", font_color=colors.lightred, style="timechanger_button_style"})
                gui.add({type="button", name="timechanger_but_fastest", caption=">>", font_color=colors.lightred, style="timechanger_button_style"})
                gui.add({type="sprite-button", name="timechanger_but_lock", sprite="sprite_timechanger_lock_open", clicked_sprite="sprite_timechanger_lock_closed", style="timechanger_sprite_style"})
        end
        return(gui)
end

function update_guis()
        for _, player in pairs(game.players) do
                if player.connected then
                        local flow = build_gui(player)
                        local s

                        if game.speed == 1 then
                                flow.timechanger_but_speed.caption = "x1"
                        elseif game.speed < 1 then
                                s = string.format("/%1.0f", 1/game.speed)
                                flow.timechanger_but_speed.caption = s
                        elseif game.speed > 1 then
                                s = string.format("x%1.0f", game.speed)
                                flow.timechanger_but_speed.caption = s
                        end

                end
        end
end

local interface = {}

function interface.reset()
	for _, player in pairs(game.players) do
		if player.gui.top.timechanger_flow then	
			player.gui.top.timechanger_flow.destroy()
		end
	end
	
	update_guis()
end

function interface.setspeed(speed)
	if speed == nil then speed = 1 end
	speed = math.floor(speed) -- ensure integer
	if speed < 1 then speed = 1 end
	if speed > settings.global["timechanger-max-game-speed"].value then
		speed = settings.global["timechanger-min-game-speed"].value
	end
	storage.speed = speed
	update_guis()
end

function interface.off()
	storage.display = false
	
	for _, player in pairs(game.players) do
		if player.connected and player.gui.top.timechanger_flow then player.gui.top.timechanger_flow.destroy() end
	end
end

function interface.on( )
	storage.display = true

	update_guis()
end

remote.add_interface("timechanger", interface)