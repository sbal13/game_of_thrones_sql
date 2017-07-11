class DataSorter

	def self.hash_to_unique(info_hash, *columns)
		info_hash.collect do |row|

			columns.collect do |column|
				row[column]
			end
		end.flatten.compact.uniq
	end

	def self.select_columns(info_hash, *columns)
		info_hash.collect do |row|

			columns.collect do |column|
				row[column]
			end
		end
	end


	def self.normalize_names(names_array)
		names_array.map do |name_string|
			if name_string.include?('/')
				first_names, last_name = name_string.split(' ')
				name1, name2 = first_names.split('/')
				name1 += " " + last_name
				name2 += " " + last_name
				[name1,name2]
			elsif name_string.include?(',')
				name_string.split(", ")
			else
				name_string
			end
		end.flatten.uniq

	end



end



#
#DataSorter.hash_to_unique(CSVParser.parse_to_hash, :attacker_1, :attacker_2, :attacker_3, :attacker_4, :defender_1, :defender_2, :defender_3, :defender_4)
#DataSorter.normalize_names(DataSorter.hash_to_unique(CSVParser.parse_to_hash, :attacker_king, :defender_king, :attacker_commander, :defender_commander))
#DataSorter.hash_to_unique(CSVParser.parse_to_hash, :battle_type)
#DataSorter.hash_to_unique(CSVParser.parse_to_hash, :location)
#DataSorter.hash_to_unique(CSVParser.parse_to_hash, :region)