class Battle_Defender_House < ClassCreator
	def self.populate_relational_table
		battles =  DataSorter.select_columns(CSVParser.parse_to_hash, :name)
		defenders = DataSorter.select_columns(CSVParser.parse_to_hash, :defender_1, :defender_2, :defender_3, :defender_4)
		defenders.map!{|defender_list| defender_list.compact}

		relational_table_data = [battles, defenders].transpose


		relational_table_data.each do |row|
			battle = Battle.find_by(name: row[0])[0]
			houses = House.all.select{ |house| row[1].include?(house.name)}
			houses.each do |house|
				Battle_Defender_House.create(battle_id: battle.id, house_id: house.id)
			end
		end
	end
end