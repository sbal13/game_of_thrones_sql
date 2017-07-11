class ClassCreator


	def initialize(info_hash)
		self.class.create_accessors

		info_hash.each {|key, value| self.send("#{key}=", value)}
		self
	end

	def help

		puts "___________________________________________________"
		puts "The following methods are available to class #{self.class}:"
		puts ""
		puts (self.methods - self.class.methods).sort
		puts "___________________________________________________"
		return
	end

	def self.find_by(param)
		sql = <<-SQL
			SELECT *
			FROM #{self.table_name}
			WHERE #{param.keys[0].to_s} = ?;
		SQL
		self.new_from_db(DB[:conn].execute(sql, param.values[0]))
		
	end

	def self.create(info_hash)
		new_inst = self.new(info_hash)
		new_inst.save
	end

	def save
		question_marks = self.insert_values.length.times.map{"?"}.join(", ")
		sql = <<-SQL 
				INSERT INTO #{self.class.table_name}
				 (#{remove_headers.join(", ")})
				 VALUES
				 (#{question_marks});
			   SQL
		DB[:conn].execute(sql, *self.insert_values)
	end

	def update
		sql = <<-SQL
			UPDATE #{self.class.table_name}
			SET #{prepare_for_update.join(", ")}
			WHERE id = #{self.id}
		SQL
		DB[:conn].execute(sql)
	end

	def self.help
		puts "The following methods are class methods"
		(self.methods - self.class.methods).each{|meth| puts meth}
	end

	def remove_headers
		self.class.obtain_headers.select{|header| self.send(header.to_sym) && !(header == "id")}
	end

	def insert_values
		headers = self.class.obtain_headers
		headers.collect {|header| self.send(header.to_sym) if header != "id"}.compact
		# values.collect{|value| value.class == String ? "#{value}" : value}
	end

	def prepare_for_update
		headers = remove_headers
		values = insert_values
		(0..headers.length-1).to_a.collect do |index| 
			values[index].class == String ? "#{headers[index]} = '#{values[index]}'" : "#{headers[index]} = #{values[index]}"
		end
	end

	def self.new_from_db(values)
		headers = self.obtain_headers

		values.collect do |value|
			info_hash = {}
			headers.each_with_index {|header, index| info_hash[header] = value[index]}
			self.new(info_hash)
		end
	end


	def self.all
		sql = <<-SQL
			SELECT *
			FROM #{self.table_name}
			SQL

		self.new_from_db(DB[:conn].execute(sql))
		
	end

	def self.create_from_array(data_array)
		data_array.each do |row|
			hash = {}
			obtain_headers_no_id.each_with_index do |header, index|
				hash[header] =  row[index]
			end

			self.create(hash)
		end

	end

	private

	def self.table_name
		self.to_s.downcase + 's'
	end

	def self.obtain_headers

		sql = "PRAGMA table_info(#{self.table_name})"

		DB[:conn].execute(sql).map{|table_info_row| table_info_row[1]}
	end

	def self.obtain_headers_no_id
		self.obtain_headers[1..-1]
	end

	def self.create_accessors

		headers = obtain_headers
		headers.each {|header| self.send(:attr_accessor, header.to_sym)}
	end

end