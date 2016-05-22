require "settings"

gui = {
	main_btn_name = "snaptorio-btn",
	main_frame_name = "snaptorio-main-frame",
	do_snap_btn_name = "snaptorio-do-snap",
	settings_btn_name = "do-snap-btn-name",
	main_frame = nil,
	init = function(player)
		if (player.gui.top[gui.main_btn_name] ~= nil) then
			player.gui.top[gui.main_btn_name].destroy()
		end
		
		gui.destroy_main_frame(player)
		
		player.gui.top.add{type="button", name=gui.main_btn_name, caption="Snap!"}
	end,

	toggle_main_frame = function(player)
		if (player.gui.left[gui.main_frame_name] ~= nil) then
			gui.destroy_main_frame(player)
		else
			gui.show_main_frame(player)
		end
	end,
	
	destroy_main_frame = function(player)
		if (player.gui.left[gui.main_frame_name] ~= nil and player.gui.left[gui.main_frame_name].valid) then
			player.gui.left[gui.main_frame_name].destroy()
		end
		
		if (gui.main_frame ~= nil and gui.main_frame.valid) then
			gui.main_frame.destroy()
			gui.main_frame = nil
		end
		settings_gui.destroy_frame(player)
	end,
	
	show_main_frame = function(player)
		gui.destroy_main_frame(player)
		gui.main_frame = player.gui.left.add{type="frame", name=gui.main_frame_name, caption="Snaptorio", direction="vertical"}
		local snap_config = gui.main_frame.add{type="flow", name="snaptorio-main-flow"}
		snap_config.add{type="button", name=gui.do_snap_btn_name, caption="Snap!"}
		snap_config.add{type="button", name=gui.settings_btn_name, caption="Settings"}
	end
}

settings_gui = {
	frame_name = "snaptorio-settings",
	frame = nil,
	zoom_textfield = nil,
	show_gui_checkbox = nil,
	show_entity_info_checkbox = nil,
	resolution_textfields = {
		x=nil,
		y=nil
	},
	
	toggle_frame = function(player)
		if (gui.main_frame ~= nil and gui.main_frame[settings_gui.frame_name] ~= nil) then
			settings_gui.destroy_frame(player)
		else
			settings_gui.show_frame(player)
		end
	end,
	
	destroy_frame = function(player)
		save_settings(player)
		if (player.gui.left[gui.main_frame_name] and player.gui.left[gui.main_frame_name][settings_gui.frame_name] and player.gui.left[gui.main_frame_name][settings_gui.frame_name].valid) then
			player.gui.left[gui.main_frame_name][settings_gui.frame_name].destroy()
		end
		
		if (gui.main_frame and gui.main_frame.valid and gui.main_frame[settings_gui.frame_name]and gui.main_frame[settings_gui.frame_name].valid) then
			gui.main_frame[settings_gui.frame_name].destroy()
		end
		
		
		if (settings_gui.frame ~= nil and settings_gui.frame.valid) then
			settings_gui.frame.destroy()
			settings_gui.frame = nil
		end
		
		settings_gui.zoom_textfield = nil
		
		settings_gui.show_gui_checkbox = nil
		
		settings_gui.show_entity_info_checkbox = nil
		
		settings_gui.resolution_textfields = {
			x=nil,
			y=nil
		}
	end,
	
	show_frame = function(player)
		settings_gui.destroy_frame(player)
		settings_gui.frame = player.gui.left[gui.main_frame_name].add{type="flow", name=settings_gui.frame_name, direction="vertical"}
		settings_gui.add_show_entity_info()
		settings_gui.add_zoom()
		settings_gui.add_resolution()
		-- Show GUI doesn't seem to work in the context of a mod...
		--settings_gui.add_show_gui()
	end,
	
	add_zoom = function()
		local flow = settings_gui.frame.add{type="flow", name="zoom-flow", direction="horizontal"}
		flow.add{type="label", caption="Zoom: "}
		settings_gui.zoom_textfield = flow.add{type="textfield", name="zoom-level", text=snap_settings.zoom}
	end,
	
	add_show_gui = function()
		local flow = settings_gui.frame.add{type="flow", name="show-gui-flow", direction="horizontal"}
		settings_gui.show_gui_checkbox = flow.add{type="checkbox", name="show-gui-checkbox", state=snap_settings.show_gui}
		flow.add{type="label", caption="Show Gui"}
	end,
	
	add_show_entity_info = function()
		local flow = settings_gui.frame.add{type="flow", name="show-entity-info-flow", direction="horizontal"}
		settings_gui.show_entity_info_checkbox = flow.add{type="checkbox", name="show-entity-info-checkbox", state=snap_settings.show_entity_info}
		flow.add{type="label", caption="Show Entity Info"}
	end,
	
	add_resolution = function()
		local x = ""
		local y = ""
		
		if (snap_settings.resolution ~= nil and snap_settings.resolution.x~=nil) then
			local temp_x = tonumber(snap_settings.resolution.x)
			if (temp_x ~= nil) then
				x = temp_x
			end
		end
		
		if (snap_settings.resolution ~= nil and snap_settings.resolution.y~=nil) then
			local temp_y = tonumber(snap_settings.resolution.y)
			if (temp_y ~= nil) then
				y = temp_y
			end
		end
		
		local flow = settings_gui.frame.add{type="flow", name="resolution-flow", direction="horizontal"}
		flow.add{type="label", caption="Resolution (WxH): "}
		settings_gui.resolution_textfields.x = flow.add{type="textfield", name="resolution_x", text=x}
		flow.add{type="label", caption=" x "}
		settings_gui.resolution_textfields.y = flow.add{type="textfield", name="resolution_y", text=y}
	
	end
}