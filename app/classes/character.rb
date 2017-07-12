class Character < ClassCreator
	def self.populate_from_data_sorter(*data_set)
		character_names = DataSorter.hash_to_unique(CSVParser.parse_to_hash, *data_set)
		characters = DataSorter.normalize_names(character_names).map{|character| [character]}
		self.create_from_array(characters)
	end


	##RUBY QUERIES

	def attacking_battles
		
		battles1 = Battle_Attacker_King.all.select{|battle_relation| battle_relation.character_id == self.id}
		battles2 = Battle_Attacker_Commander.all.select do|battle_relation| 
			battle_relation.character_id == self.id && battles1.none? { |battle1_relation| battle1_relation.battle_id == battle_relation.battle_id}
		end

		battles1.concat(battles2)
	end

	def attacking_losses
		self.attacking_battles.select do |battle_relation| 
			Battle.find_by(id: battle_relation.battle_id)[0].outcome == "loss"
		end
	end

	def self.most_attacks
		char_num_attacks = self.all.collect do |character| 
			[character, character.attacking_battles.length]
		end
		highest_attacks = char_num_attacks.sort_by{|row| row[1]}.last[1]
		char_num_attacks.collect{|char| char[0] if char[1] == highest_attacks}.compact

	end

	def self.most_losses
		char_num_losses = self.all.collect do |character|
			[character, character.attacking_losses.length]
		end


		highest_losses = char_num_losses.sort_by{|row| row[1]}.last[1]
		char_num_losses.collect{|char| char[0] if char[1] == highest_losses}.compact
	end

	##SQL QUERIES

	def self.most_attacks_sql_query
		DB[:conn].execute(self.participations)
		DB[:conn].execute(self.drop_count_table)
		DB[:conn].execute(self.counted_participations)
		DB[:conn].execute(self.drop_max_count)
		DB[:conn].execute(self.max_counts_query)
		DB[:conn].execute(self.final_query)
	end

	def self.most_losses_sql_query
		DB[:conn].execute(self.participations)
		DB[:conn].execute(self.drop_count_table)
		DB[:conn].execute(self.counted_participations_by_loss)
		DB[:conn].execute(self.drop_max_count)
		DB[:conn].execute(self.max_counts_query)
		DB[:conn].execute(self.final_query)

	end

	private 

	def self.participations
		<<-SQL
			CREATE TEMPORARY TABLE IF NOT EXISTS participations AS 
			SELECT * FROM battle_attacker_commanders 
			UNION SELECT * FROM battle_attacker_kings
		SQL
	end


	def self.counted_participations
		<<-SQL
			CREATE TEMPORARY TABLE count_table AS
			SELECT character_id, COUNT(DISTINCT battle_id) AS cnt
			FROM participations
			GROUP BY character_id;
		SQL
	end

	def self.counted_participations_by_loss
		<<-SQL
			CREATE TEMPORARY TABLE count_table AS
			SELECT character_id, COUNT(DISTINCT battle_id) AS cnt
			FROM participations
			INNER JOIN battles
			ON battles.id = participations.battle_id
			WHERE battles.outcome = 'loss'
			GROUP BY character_id;
		SQL
	end


	def self.max_counts_query
		<<-SQL
			CREATE TEMPORARY TABLE max_count AS
			SELECT  MAX(cnt) AS max_value
			FROM count_table;
		SQL
	end

	def self.final_query
		<<-SQL
			SELECT characters.name, cnt
			FROM characters
			INNER JOIN count_table
			ON characters.id = count_table.character_id
			INNER JOIN max_count
			ON max_value = cnt
			GROUP BY characters.name 
		SQL
	end


end