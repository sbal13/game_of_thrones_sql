 class TableManager
  def self.drop_tables
  	sql = File.read("drop_tables.sql")
    DB[:conn].execute_batch(sql)
  end

  def self.populate
  	Region.populate_from_data_sorter(:region)
  	Location.populate_from_data_sorter(:location)
  	House.populate_from_data_sorter(:attacker_1, :attacker_2, :attacker_3, :attacker_4, :defender_1, :defender_2, :defender_3, :defender_4)
  	Character.populate_from_data_sorter(:attacker_king, :defender_king, :attacker_commander, :defender_commander)
  	Battle_Type.populate_from_data_sorter(:battle_type)
  	Battle.populate_from_data_sorter(:name, :year, :attacker_outcome, :battle_type, :major_death, :major_capture, :attacker_size, :defender_size, :summer, :location, :region)
  	Battle_Attacker_Commander.populate_relational_table(:attacker_commander)
  	Battle_Attacker_King.populate_relational_table(:attacker_king)
  	Battle_Attacker_House.populate_relational_table
  	Battle_Defender_Commander.populate_relational_table(:defender_commander)
  	Battle_Defender_King.populate_relational_table(:defender_king)
  	Battle_Defender_House.populate_relational_table
  end

  def self.create
  	SchemaCreator.create
  end


end