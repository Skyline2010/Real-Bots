local team_ai_set_carrying_bag = TeamAIMovement.set_carrying_bag
local team_ai_pre_destroy = TeamAIMovement.pre_destroy

function TeamAIMovement:set_carrying_bag(carry_unit)
	local old_unit = self._carry_unit

	team_ai_set_carrying_bag(self, carry_unit)

	if alive(old_unit) and old_unit ~= carry_unit then
		old_unit:set_visible(true)
	end

	self:_destroy_visual_carry()

	if alive(carry_unit) then
		carry_unit:set_visible(false)
		self:_create_visual_carry(carry_unit:carry_data():carry_id())
		RealBots.show_bot_carry_info(self._unit, carry_unit)
	else
		RealBots.hide_bot_carry_info(self._unit)
	end
end

function TeamAIMovement:_create_visual_carry(carry_id)
	local carry_tweak = carry_id and tweak_data.carry[carry_id]

	if not carry_tweak then
		return
	end

	if carry_tweak.visual_unit_name then
		local unit_name = carry_tweak.visual_unit_name

		if not PackageManager:has(Idstring(unit_name), Idstring("unit")) then
			unit_name = tweak_data.carry.default_visual_unit
		end

		self._visual_carry_unit = safe_spawn_unit(Idstring(unit_name), self._unit:position(), self._unit:rotation())
		self._unit:link(Idstring("Hips"), self._visual_carry_unit, self._visual_carry_unit:orientation_object():name())

		for _, object_name in ipairs(RealBots.CARRY_OBJECTS) do
			local parent_object = self._unit:get_object(Idstring(object_name))
			local bag_object = self._visual_carry_unit:get_object(Idstring(object_name))

			if parent_object and bag_object then
				bag_object:link(parent_object)
				bag_object:set_position(parent_object:position())
				bag_object:set_rotation(parent_object:rotation())
			end
		end
	else
		local object = self._unit:get_object(Idstring(carry_tweak.visual_object or "g_lootbag"))

		if object then
			object:set_visibility(true)
			self._visual_carry_object = object
		end
	end
end

function TeamAIMovement:_destroy_visual_carry()
	if alive(self._visual_carry_unit) then
		self._visual_carry_unit:set_slot(0)
	end

	self._visual_carry_unit = nil

	if self._visual_carry_object then
		self._visual_carry_object:set_visibility(false)
		self._visual_carry_object = nil
	end
end

function TeamAIMovement:pre_destroy(...)
	if alive(self._carry_unit) then
		self._carry_unit:set_visible(true)
	end

	self:_destroy_visual_carry()

	return team_ai_pre_destroy(self, ...)
end
