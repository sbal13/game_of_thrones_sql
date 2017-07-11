class SchemaCreator
	def self.create
		characters = TableCreator.new('characters', name: "TEXT")
		characters.create_table

		houses = TableCreator.new('houses', {name: "TEXT"})
		houses.create_table

		battle_types = TableCreator.new('battle_types', {name: "TEXT"})
		battle_types.create_table

		locations = TableCreator.new('locations', {name: "TEXT"})
		locations.create_table

		regions = TableCreator.new('regions', {name: "TEXT"})
		regions.create_table

		battle_header_hash = {
			name: "TEXT",
			year: "INTEGER",
			outcome: "TEXT",
			battle_type_id: "INTEGER",
			major_death: "BOOLEAN",
			major_capture: "BOOLEAN",
			attacker_size: "INTEGER",
			defender_size: "INTEGER",
			summer: "BOOLEAN",
			location_id: "INTEGER",
			region_id: "INTEGER",
		}

		battles = TableCreator.new('battles', battle_header_hash)
		battles.create_table

		battle_attacker_kings = TableCreator.new('battle_attacker_kings', {battle_id: "INTEGER", character_id: "INTEGER"})
		battle_attacker_kings.create_table

		battle_defender_kings = TableCreator.new('battle_defender_kings', {battle_id: "INTEGER", character_id: "INTEGER"})
		battle_defender_kings.create_table

		battle_attacker_commanders = TableCreator.new('battle_attacker_commanders', {battle_id: "INTEGER", character_id: "INTEGER"})
		battle_attacker_commanders.create_table

		battle_defender_commanders = TableCreator.new('battle_defender_commanders', {battle_id: "INTEGER", character_id: "INTEGER"})
		battle_defender_commanders.create_table

		battle_attacker_houses = TableCreator.new('battle_attacker_houses', {house_id: "INTEGER", battle_id: "INTEGER"})
		battle_attacker_houses.create_table

		battle_defender_houses = TableCreator.new('battle_defender_houses', {house_id: "INTEGER", battle_id: "INTEGER"})
		battle_defender_houses.create_table
	end
end
