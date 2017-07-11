class TableCreator

	attr_accessor :table_name, :columns

	def initialize(table_name, columns)
		@table_name = table_name
		@columns = columns
	end

	def create_table
	    create_table_string = columns.map do |attribute, datatype|
	      "#{attribute} #{datatype}"
	    end.join(", ")

	   sql = <<-SQL
	      CREATE TABLE IF NOT EXISTS #{self.table_name}
	      (id INTEGER PRIMARY KEY, #{create_table_string})
	    SQL
    	DB[:conn].execute(sql)
  	end
end
