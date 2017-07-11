class Battle < ClassCreator
	def self.populate_from_data_sorter

		battle_info = DataSorter.select_columns(CSVParser.parse_to_hash, :name, :year, :attacker_outcome, :battle_type, :major_death, :major_capture, :attacker_size, :defender_size, :summer, :location, :region)
		battle_info.each do |row|
			row[3] = Battle_Type.find_by(name: row[3])[0].id unless row[3].nil?
			row[9] = Location.find_by(name: row[9])[0].id unless row[9].nil?
			row[10] = Region.find_by(name: row[10])[0].id unless row[10].nil?
		end

		self.create_from_array(battle_info)
	end


end