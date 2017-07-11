 class SQLRunner
  def execute_delete_table
    sql = File.read("../delete.sql")
    DB[:conn].execute_batch(sql)
  end
end