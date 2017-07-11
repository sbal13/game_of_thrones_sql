require 'bundler/setup'

Bundler.require

require 'pry'
require 'csv'
require 'sqlite3'

require_relative '../app/CSVparser.rb'
require_relative '../app/datasorter.rb'
require_relative '../app/tablecreator.rb'
require_relative '../app/schemacreator.rb'
require_relative '../app/classcreator.rb'
require_relative '../app/classes/battle_type.rb'
require_relative '../app/classes/character.rb'
require_relative '../app/classes/house.rb'
require_relative '../app/classes/location.rb'
require_relative '../app/classes/region.rb'
require_relative '../app/classes/battle.rb'


# require_relative 'sql_runner.rb'

DB = {:conn => SQLite3::Database.new('../db/game_of_thrones.db')}
# SQLRunner.execute_delete_table

Pry.start
