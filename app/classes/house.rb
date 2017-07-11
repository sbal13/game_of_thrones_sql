class House < ClassCreator

	def self.populate_from_data_sorter

		houses = DataSorter.hash_to_unique(CSVParser.parse_to_hash, :attacker_1, :attacker_2, :attacker_3, :attacker_4, :defender_1, :defender_2, :defender_3, :defender_4)
		houses.map!{|house| [house]}

		self.create_from_array(houses)
	end
end