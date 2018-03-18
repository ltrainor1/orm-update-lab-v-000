require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :name, :grade, :id
@@all = []
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
end

def self.drop_table
  DB[:conn].execute("DROP TABLE students")
end

def self.find_by_name(name)
  sql =<<-SQL
    SELECT * FROM students
    WHERE NAME = ?
  SQL
  row = DB[:conn].execute(sql, name)[0]
  if row == nil
    nil
  else
    @@all.detect do |student|
      student.name == row[1]
    end
  end
end

def save
  existing = Student.find_by_name(self.name)
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT MAX(id) FROM students")[0][0]

end

def self.create(name, grade)
  sql = <<-SQL
    INSERT INTO students(name, grade)
    VALUES(?,?)
    SQL
    DB[:conn].execute(sql, name, grade)
end

def self.new_from_db(row)
  new_student = new(row[1],row[2],row[0])
end

def update
  existing = Student.find_by_name(self.name)
  if existing == []
    new = Student.create(self.name, self.grade)
  end
    sql = <<-SQL
    UPDATE students SET name = ?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.id)

    sql = <<-SQL
    UPDATE students SET grade = ?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.grade, self.id)

end

end
