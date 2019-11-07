class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_stu = Student.new()
    new_stu.id = row[0]
    new_stu.name = row[1]
    new_stu.grade = row[2]
    new_stu
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    all_stu = DB[:conn].execute(sql)
    all_stu.map do |row| 
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
  SQL

  stu = DB[:conn].execute(sql, name)[0]
  new_from_db(stu)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    where grade = 9
  SQL

  all_stu = DB[:conn].execute(sql)
  all_stu.map do |row| 
    self.new_from_db(row)
  end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    where grade != 12
  SQL

  all_stu = DB[:conn].execute(sql)
  all_stu.map do |row| 
    self.new_from_db(row)
  end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students
    LIMIT ?
  SQL

  all_stu = DB[:conn].execute(sql, num)
  all_stu.map do |row| 
    self.new_from_db(row)
  end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      where grade = 10
      LIMIT 1
    SQL

  all_stu = DB[:conn].execute(sql)
  mapped =all_stu.map do |row| 
    self.new_from_db(row)
  end.first
  
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    where grade = ?
  SQL

  all_stu = DB[:conn].execute(sql, grade)
  all_stu.map do |row| 
    self.new_from_db(row)
  end
  end
end
