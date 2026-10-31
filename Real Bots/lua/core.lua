RealBots = RealBots or {}

RealBots.CARRY_OBJECTS = {
	"Spine",
	"Spine1",
	"Spine2",
	"LeftShoulder",
	"RightShoulder",
	"LeftUpLeg",
	"RightUpLeg"
}

function RealBots.get_bot_color_id(criminals, name)
	name = CriminalsManager.convert_new_to_old_character_workname(name) or name

	local used = {}

	for _, data in pairs(criminals._characters) do
		if data.taken and not data.data.ai and data.peer_id then
			used[data.peer_id] = true
		end
	end

	local index = 0

	for _, character in ipairs(tweak_data.criminals.characters) do
		local data = criminals:character_by_name(character.name)

		if data and data.taken and data.data.ai and data.unit then
			index = index + 1

			if data.name == name then
				local free = 0

				for id = 1, tweak_data.max_players do
					if not used[id] then
						free = free + 1

						if free == index then
							return id
						end
					end
				end

				return #tweak_data.chat_colors
			end
		end
	end

	return #tweak_data.chat_colors
end

function RealBots.amount_of_winning_bots()
	local state = managers.groupai and managers.groupai:state()

	return state and state.amount_of_winning_ai_criminals and state:amount_of_winning_ai_criminals() or 0
end

function RealBots.show_bot_carry_info(unit, carry_unit)
	local data = managers.criminals and managers.criminals:character_data_by_unit(unit)

	if data and data.panel_id and managers.hud then
		local carry_id = carry_unit:carry_data():carry_id()

		managers.hud:set_teammate_carry_info(data.panel_id, carry_id, managers.loot:get_real_value(carry_id, carry_unit:carry_data():multiplier() or 1))
	end

	RealBots.set_bot_label_bag(unit, true)
end

function RealBots.hide_bot_carry_info(unit)
	local data = managers.criminals and managers.criminals:character_data_by_unit(unit)

	if data and data.panel_id and managers.hud then
		managers.hud:remove_teammate_carry_info(data.panel_id)
	end

	RealBots.set_bot_label_bag(unit, false)
end

function RealBots.set_bot_label_bag(unit, state)
	local hud = managers.hud
	local labels = hud and hud._hud and hud._hud.name_labels

	for _, label in pairs(labels or {}) do
		if label.movement and label.movement._unit == unit then
			local bag = label.panel:child("bag")

			if bag then
				bag:set_visible(state)
			end

			return
		end
	end
end
