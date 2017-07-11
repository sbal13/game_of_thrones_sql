class Region < ClassCreator
	def self.populate_from_data_sorter

		regions = DataSorter.hash_to_unique(CSVParser.parse_to_hash, :region)
		regions.map!{|region| [region]}

		self.create_from_array(regions)
	end
end