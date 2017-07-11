class Location < ClassCreator
	def self.populate_from_data_sorter

		locations = DataSorter.hash_to_unique(CSVParser.parse_to_hash, :location)
		locations.map!{|location| [location]}

		self.create_from_array(locations)
	end
end