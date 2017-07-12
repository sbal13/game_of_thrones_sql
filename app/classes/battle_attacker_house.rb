class Battle_Attacker_House < ClassCreator
	def self.populate_relational_table
		battles =  DataSorter.select_columns(CSVParser.parse_to_hash, :name)
		attackers = DataSorter.select_columns(CSVParser.parse_to_hash, :attacker_1, :attacker_2, :attacker_3, :attacker_4)
		attackers.map!{|attacker_list| attacker_list.compact}

		relational_table_data = [battles, attackers].transpose


		relational_table_data.each do |row|
			battle = Battle.find_by(name: row[0])[0]
			houses = House.all.select{ |house| row[1].include?(house.name)}
			houses.each do |house|
				self.create(battle_id: battle.id, house_id: house.id)
			end
		end
	end
end