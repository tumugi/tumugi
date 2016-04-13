task :task1 do
  requires [:task2, :task3]
  run { puts 'task1#run' }
end

task :task2 do
  requires [:task4]
  run { puts 'task2#run' }
end

task :task3 do
  requires [:task4]
  run { puts 'task3#run' }
end

task :task4 do
  run do
    puts 'task4#run'
    sleep 1
  end
end
