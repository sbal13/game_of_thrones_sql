class Location < ClassCreator
	def battles

		Battle.all.select{|battle| battle.location_id == self.id}
	end

	def self.most_battles
		loc_num_battles = self.all.collect do |location|
			[location, location.battles.length]
		end

		highest_num = loc_num_battles.sort_by{|row| row[1]}.last[1]
		loc_num_battles.collect{|loc| loc[0] if loc[1] == highest_num}.compact
	end
end


