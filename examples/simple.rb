task :task1 do |t|
  t.requires [:task2, :task3]
  t.run { puts 'task1#run' }
end

task :task2 do |t|
  t.requires [:task4]
  t.run { puts 'task2#run' }
end

task :task3 do |t|
  t.requires [:task4]
  t.run { puts 'task3#run' }
end

task :task4 do |t|
  t.run do
    puts 'task4#run'
    sleep 3
  end
end
