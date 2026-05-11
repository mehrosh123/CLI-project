require 'json'

class Task
  attr_accessor :title, :completed

  def initialize(title, completed = false)
    @title = title
    @completed = completed
  end

  # Data ko JSON format mein convert karnay ke liye
  def to_hash
    { title: @title, completed: @completed }
  end
end

class TodoList
  FILE_NAME = 'tasks.json'

  def initialize
    @tasks = load_tasks
  end

  def add_task(title)
    @tasks << Task.new(title)
    save_tasks
    puts "Task added successfully!"
  end

  def view_tasks
    if @tasks.empty?
      puts "No tasks found."
    else
      @tasks.each_with_index do |task, index|
        status = task.completed ? "[✓]" : "[ ]"
        puts "#{index + 1}. #{status} #{task.title}"
      end
    end
  end

  def mark_completed(index)
    if @tasks[index]
      @tasks[index].completed = true
      save_tasks
      puts "Task marked as completed!"
    else
      puts "Invalid task number."
    end
  end

  def delete_task(index)
    if @tasks.delete_at(index)
      save_tasks
      puts "Task deleted."
    else
      puts "Invalid task number."
    end
  end

  def show_separated
    pending = @tasks.select { |t| !t.completed }
    done = @tasks.select { |t| t.completed }

    puts "\n--- Pending Tasks ---"
    pending.each { |t| puts "- #{t.title}" }

    puts "\n--- Completed Tasks ---"
    done.each { |t| puts "- #{t.title}" }
  end

  private

  def save_tasks
    File.open(FILE_NAME, 'w') do |f|
      f.write(JSON.pretty_generate(@tasks.map(&:to_hash)))
    end
  end

  def load_tasks
    if File.exist?(FILE_NAME)
      file_data = JSON.parse(File.read(FILE_NAME))
      file_data.map { |t| Task.new(t['title'], t['completed']) }
    else
      []
    end
  end
end

# --- Application Flow ---
todo = TodoList.new

loop do
  puts "\n==== TODO LIST MENU ===="
  puts "1. Add Task"
  puts "2. View All Tasks"
  puts "3. Mark Task Completed"
  puts "4. Delete Task"
  puts "5. Show Pending/Completed Separately"
  puts "6. Exit"
  print "Choose an option: "
  
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter task title: "
    title = gets.chomp
    todo.add_task(title)
  when 2
    todo.view_tasks
  when 3
    todo.view_tasks
    print "Enter task number to mark done: "
    num = gets.chomp.to_i
    todo.mark_completed(num - 1)
  when 4
    todo.view_tasks
    print "Enter task number to delete: "
    num = gets.chomp.to_i
    todo.delete_task(num - 1)
  when 5
    todo.show_separated
  when 6
    puts "Goodbye!"
    break
  else
    puts "Invalid option, please try again."
  end
end