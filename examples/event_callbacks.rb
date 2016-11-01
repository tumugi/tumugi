task :task1 do
  requires [:task2, :task3]
  run { log 'task1#run' }
end

task :task2 do
  requires [:task4]
  run { raise "error in #{id}" }
  on_retry do
    log 'task2#on_retry'
  end
  on_failure do
    log 'task2#on_failure'
  end
end

task :task3 do
  requires [:task4]
  run { log 'task3#run' }
  on_success do
    log 'task3#on_success'
  end
end

task :task4 do
  run do
    log 'task4#run'
    sleep 1
  end
  on_success do
    log 'task4#on_success'
  end
end

on_failure do
  log 'task1#on_failure'
end
