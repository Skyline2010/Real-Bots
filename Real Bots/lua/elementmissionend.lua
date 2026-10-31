local element_mission_end_on_executed = ElementMissionEnd.on_executed

function ElementMissionEnd:on_executed(instigator)
	if self._values.enabled and self._values.state == "success" and managers.platform:presence() == "Playing" then
		local num_winners = managers.network:session():amount_of_alive_players() + RealBots.amount_of_winning_bots()

		managers.network:session():send_to_peers("mission_ended", true, num_winners)
		game_state_machine:change_state_by_name("victoryscreen", {
			num_winners = num_winners,
			personal_win = alive(managers.player:player_unit())
		})

		ElementMissionEnd.super.on_executed(self, instigator)

		return
	end

	return element_mission_end_on_executed(self, instigator)
end
