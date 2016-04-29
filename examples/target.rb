require 'tumugi/target/file_target'

task :task1 do
  requires [:task2, :task3]

  output do
    Tumugi::Target::FileTarget.new("/tmp/tumugi_#{id}.txt")
  end

  run do
    log 'task1#run'
    File.write(output.path, 'done')
  end
end

task :task2 do
  requires [:task4]

  output do
    Tumugi::Target::FileTarget.new("/tmp/tumugi_#{id}.txt")
  end

  run do
    log 'task2#run'
    File.write(output.path, 'done')
  end
end

task :task3 do
  requires [:task4]

  output do
    Tumugi::Target::FileTarget.new("/tmp/tumugi_#{id}.txt")
  end

  run do
    log 'task3#run'
    File.write(output.path, 'done')
  end
end

task :task4 do
  output do
    Tumugi::Target::FileTarget.new("/tmp/tumugi_#{id}.txt")
  end

  run do
    log 'task4#run'
    File.write(output.path, 'done')
  end
end
