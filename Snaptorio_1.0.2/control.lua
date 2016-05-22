require "defines"
require "gui"
require "settings"

script.on_init(function()
	for _, player in pairs(game.players) do
		gui.init(player)
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	gui.init(game.players[event.player_index])
end)

script.on_event(defines.events.on_gui_click, function(event) 
	local p = game.players[event.element.player_index]
	local name = event.element.name
	if (name == gui.main_btn_name) then -- Main GUI button up top
		gui.toggle_main_frame(p)
	elseif (name == gui.do_snap_btn_name) then
		take_screenshot(p)
	elseif (name == gui.settings_btn_name) then
		settings_gui.toggle_frame(p)
	end
end)

local DEV = false

function take_screenshot(player)
	local filename = game.tick .. ".png"
	save_settings(player)
	
	local use_resolution = true
	if (snap_settings.resolution == nil or snap_settings.resolution.x == nil or snap_settings.resolution.y == nil) then
		use_resolution = false
	end
	
	if (DEV) then
		local show_gui = "False" -- default
		if (snap_settings.show_gui) then show_gui = "True" end
		
		local show_entity_info = "False"
		if (snap_settings.show_entity_info) then show_entity_info = "True" end
		
		player.print("zoom: " .. snap_settings.zoom)
		player.print("show_gui: " .. show_gui)
		player.print("show_entity_info: " .. show_entity_info)
		
		if (use_resolution) then
			player.print("Using resolution of {x=" .. snap_settings.resolution.x .. ",y=" .. snap_settings.resolution.y .. "}")
		else
			player.print("Not using Resolution")
		end
	end
	player.print("Saving screenshot as " .. filename)
	if (not use_resolution) then
		game.take_screenshot({
			player=player, 
			path="Snaptorio/" .. filename, 
			zoom=snap_settings.zoom, 
			show_entity_info=snap_settings.show_entity_info, 
			show_gui=snap_settings.show_gui
		})
	else
		game.take_screenshot({
			player=player, 
			path="Snaptorio/" .. filename, 
			zoom=snap_settings.zoom, 
			show_entity_info=snap_settings.show_entity_info, 
			show_gui=snap_settings.show_gui,
			resolution={x=snap_settings.resolution.x, y=snap_settings.resolution.y}
		})
	end
end

save_settings = function(player)
		if (settings_gui.zoom_textfield ~= nil and settings_gui.zoom_textfield.valid and settings_gui.zoom_textfield.text ~= "") then
			local new_zoom = tonumber(settings_gui.zoom_textfield.text)
			
			if (new_zoom == nil) then
				player.print("Zoom must be a number")
				settings_gui.zoom_textfield = snap_default_settings.zoom
			elseif (new_zoom > 1) then
				player.print("Zoom can not be greater than 1")
				settings_gui.zoom_textfield = snap_default_settings.zoom
			elseif (new_zoom <= 0) then
				player.print("Zoom must be greater than 0")
				settings_gui.zoom_textfield = snap_default_settings.zoom
			else
				snap_settings.zoom = new_zoom
			end
		end
		
		if (settings_gui.resolution_textfields.x ~= nil and settings_gui.resolution_textfields.x.valid and settings_gui.resolution_textfields.x.text ~= "") then
			local n = tonumber(settings_gui.resolution_textfields.x.text)
			
			if (n == nil) then
				player.print("Resolution must contain numbers")
				snap_settings.resolution = nil
			elseif (n < 1) then
				player.print("Resolution values must be greater than 1")
				snap_settings.resolution = nil
			else
				if (snap_settings.resolution == nil) then
					snap_settings.resolution = {x = n}
				else 
					snap_settings.resolution.x = n
				end
			end
		end
		
		
		if (settings_gui.resolution_textfields.y ~= nil and settings_gui.resolution_textfields.y.valid and settings_gui.resolution_textfields.y.text ~= "") then
			local n = tonumber(settings_gui.resolution_textfields.y.text)
			
			if (n == nil) then
				player.print("Resolution must contain numbers")
				snap_settings.resolution = nil
			elseif (n < 1) then
				player.print("Resolution values must be greater than 1")
				snap_settings.resolution = nil
			else
				if (snap_settings.resolution == nil) then
					snap_settings.resolution = {y = n}
				else 
					snap_settings.resolution.y = n
				end
			end
		end
		
		-- can't set just one...
		if (snap_settings.resolution ~= nil and (snap_settings.resolution.x == nil or snap_settings.resolution.y == nil)) then
			snap_settings.resolution = nil
		end
		
		if (settings_gui.show_gui_checkbox ~= nil and settings_gui.show_gui_checkbox.valid) then
			snap_settings.show_gui = settings_gui.show_gui_checkbox.state
		end
		
		if (settings_gui.show_entity_info_checkbox ~= nil and settings_gui.show_entity_info_checkbox.valid) then
			snap_settings.show_entity_info = settings_gui.show_entity_info_checkbox.state
		end
	end