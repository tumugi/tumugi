task :task1 do
  requires [:task2, :task3]
  run { log 'task1#run' }
end

task :task2 do
  requires [:task4]
  run { log 'task2#run' }
end

task :task3 do
  requires [:task4]
  run { log 'task3#run' }
end

task :task4 do
  run do
    log 'task4#run'
    sleep 1
  end
end
