class Battle_Type < ClassCreator
	def self.populate_from_data_sorter

		battle_types = DataSorter.hash_to_unique(CSVParser.parse_to_hash, :battle_type)
		battle_types.map!{|type| [type]}

		self.create_from_array(battle_types)
	end
end