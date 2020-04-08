#!/usr/bin/env ruby

# Challenge #2

# Your task is to make a really simple CRUD app using SQL and the SQLite gem. 

# Happy for you to build upon the todo app idea.

# It should have the following features.
# 1. Ask the user to create a task
# 2. Allow the user to view all their tasks
# 3. Allow the user to update a task
# 4. Allow a user to delete a task

require 'sqlite3'

# model code
# one-time database create
unless File.exist?("todo.db")
  db = SQLite3::Database.new("todo.db")
  db.execute("CREATE TABLE todos (
    id INTEGER PRIMARY KEY,
    task TEXT NOT NULL,
    done INTEGER NOT NULL
  )")
  puts "initializing database todo.db"
else
  db = SQLite3::Database.new("todo.db")
end

# controller code
def add_task(task,done,db)
  done = done==true ? 1 : 0
  db.execute("INSERT INTO todos (task, done)
    VALUES (\'#{task}\', #{done})")
end

def update_task(id,task,done,db)
  done = done == true ? 1 : 0
  db.execute("UPDATE todos
    SET done = #{done}, task = \'#{task}\'
    WHERE id = #{id};")
end

def delete_task(id,db)
  db.execute("DELETE FROM todos
    WHERE id = #{id};")
end

# view code
def create_task(db)
  puts "What task do you wish to do at a later time?"
  task = gets.chomp
  puts "Weird question, but is it already done? (y/n)"
  done = gets.downcase
  done = done.include?("y") ? true : false
  # put logic here to check if task exists already
  add_task(task,done,db)
end

def read_task(db)
  puts "   ID   |   TASK   |   STATUS   "
  puts "--------------------------------"
  db.execute("SELECT * FROM todos").each do |row|
    row.each do |value|
      print "  #{value}  "
    end
    puts
  end
end

def change_task(db)
  read_task(db)
  puts "What task ID do you wish to update?"
  id = gets.chomp.to_i
  task = db.execute("SELECT task FROM todos WHERE id = #{id}")[0][0]
  puts "What is the task really called? (press enter for no change)"
  tasktest = gets.chomp
  task = tasktest.length == 0 ? task : tasktest
  puts "Weird question, but is it already done? (y/n)"
  done = gets.downcase
  done = done.include?("y") ? true : false
  # put logic here to check if task exists already
  update_task(id,task,done,db)
end

def remove_task(db)
  read_task(db)
  puts
  puts "Enter the ID of the task you wish to delete"
  id = gets.chomp.to_i
  delete_task(id,db)
end

def menu(db)
  puts "MENU"
  puts "What would you like to do? (enter a number)"
  puts "1. list all tasks"
  puts "2. add a new task"
  puts "3. change a task"
  puts "4. delete a task"
  puts "5. exit"
  option = gets.chomp.to_i

  case option
    when 1
      read_task(db)
      menu(db)
    when 2
      create_task(db)
      menu(db)
    when 3
      change_task(db)
      menu(db)
    when 4
      delete_task(db)
      menu(db)
    when 5
      exit
    else
      menu(db)
  end
end

menu(db)