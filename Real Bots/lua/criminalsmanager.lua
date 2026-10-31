local character_color_id_by_unit = CriminalsManager.character_color_id_by_unit

function CriminalsManager:character_color_id_by_unit(unit)
	for _, data in pairs(self._characters) do
		if data.unit and data.taken and data.data.ai and unit:key() == data.unit:key() then
			return RealBots.get_bot_color_id(self, self:character_name_by_unit(unit))
		end
	end

	return character_color_id_by_unit(self, unit)
end
