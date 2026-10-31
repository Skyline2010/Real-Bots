local add_teammate_panel = HUDManager.add_teammate_panel

function HUDManager:add_teammate_panel(character_name, player_name, ai, peer_id)
	local panel_id = add_teammate_panel(self, character_name, player_name, ai, peer_id)

	if ai then
		self:set_teammate_callsign(panel_id, RealBots.get_bot_color_id(managers.criminals, character_name))
	end

	return panel_id
end
