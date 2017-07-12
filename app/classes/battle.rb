class Battle < ClassCreator
	def self.populate_from_data_sorter(*data_set)

		battle_info = DataSorter.select_columns(CSVParser.parse_to_hash, *data_set)
		battle_info.each do |row|
			row[3] = Battle_Type.find_by(name: row[3])[0].id unless row[3].nil?
			row[9] = Location.find_by(name: row[9])[0].id unless row[9].nil?
			row[10] = Region.find_by(name: row[10])[0].id unless row[10].nil?
		end
		self.create_from_array(battle_info)
	end

	##RUBY QUERIES

	def attacking_characters
		commanders = Battle_Attacker_Commander.all.select do |relational_row|
			relational_row.battle_id == self.id
		end

		kings = Battle_Attacker_King.all.select do |relational_row|
			relational_row.battle_id == self.id
		end

		commanders.concat(kings).uniq.collect{|relation| Character.find_by(id: relation.character_id)}

	end


	def self.most_common_battle_type
		Battle_Type.all.sort_by do |type|
			self.all.count{|battle| battle.battle_type_id == type.id}
		end.last
	end

	def self.attack_outnumber_defense
		self.all.select{|battle| !battle.attacker_size.nil? && !battle.defender_size.nil? && battle.attacker_size > battle.defender_size}
	end

	def self.loss_attack_outnumber_defense
		self.attack_outnumber_defense.select{|battle| battle.outcome == 'loss'}
	end


	##SQL QUERIES

	def self.most_common_by_id(param)
		count_table = <<-SQL
			CREATE TEMPORARY TABLE count_table AS
			SELECT #{param}_id, COUNT(*) AS cnt
			FROM battles
			GROUP BY #{param}_id
		SQL

		max_count = <<-SQL
			CREATE TEMPORARY TABLE max_count AS
			SELECT  MAX(cnt) AS max_value
			FROM count_table
			SQL


		sql = <<-SQL
			SELECT #{param}s.name
			FROM #{param}s
			INNER JOIN count_table
			ON #{param}s.id = count_table.#{param}_id
			INNER JOIN max_count
			ON max_value = cnt
			GROUP BY #{param}s.name 
		SQL
		DB[:conn].execute(self.drop_count_table)
		DB[:conn].execute(count_table)
		DB[:conn].execute(self.drop_max_count)
		DB[:conn].execute(max_count)
		DB[:conn].execute(sql)
	end


	def self.lost_battles_attackers_outnumber_defenders_sql_query
		sql = <<-SQL
			SELECT battles.name
			FROM battles
			WHERE battles.attacker_size > battles.defender_size AND battles.outcome = 'loss'
		SQL

		DB[:conn].execute(sql)

	end

end