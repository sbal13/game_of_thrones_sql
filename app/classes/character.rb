class Character < ClassCreator
		def self.populate_from_data_sorter

		character_names = DataSorter.hash_to_unique(CSVParser.parse_to_hash, :attacker_king, :defender_king, :attacker_commander, :defender_commander)
		characters = DataSorter.normalize_names(character_names)
		characters.map!{|character| [character]}

		self.create_from_array(characters)
	end
end