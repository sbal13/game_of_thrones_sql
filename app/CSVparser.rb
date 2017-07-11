class CSVParser
	
	def self.parse_to_hash
		info_hash = []
		CSV.foreach("../CSV/battles.csv", {:headers => true, :header_converters => :symbol}) do |row|
			info_hash << row.to_h
		end
		info_hash
	end

	def self.get_headers
		self.parse_to_hash[0].keys
	end
end