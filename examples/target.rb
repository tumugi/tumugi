task :task1 do
  requires [:task2, :task3]

  output do |task|
    Tumugi::Target::FileTarget.new("/tmp/#{task.id}.txt")
  end

  run do |task|
    puts 'task1#run'
    File.write(task.output.path, 'done')
  end
end

task :task2 do
  requires [:task4]

  output do |task|
    Tumugi::Target::FileTarget.new("/tmp/#{task.id}.txt")
  end

  run do |task|
    puts 'task2#run'
    File.write(task.output.path, 'done')
  end
end

task :task3 do
  requires [:task4]

  output do |task|
    Tumugi::Target::FileTarget.new("/tmp/#{task.id}.txt")
  end

  run do |task|
    puts 'task3#run'
    File.write(task.output.path, 'done')
  end
end

task :task4 do
  output do
    Tumugi::Target::FileTarget.new('/tmp/task4.txt')
  end

  run do |task|
    puts 'task4#run'
    File.write(task.output.path, 'done')
  end
end
