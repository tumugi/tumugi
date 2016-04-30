require 'tumugi/plugin/target_file'

task :task1 do
  requires [:task2, :task3]
  output target(:file, "/tmp/tumugi_#{id}.txt")
  run do
    log 'task1#run'
    File.write(output.path, 'done')
  end
end

task :task2 do
  requires [:task4]
  output [target(:file, "/tmp/tumugi_#{id}.txt")]
  run do
    log 'task2#run'
    File.write(output.path, 'done')
  end
end

task :task3 do
  requires [:task4]
  output { target(:file, "/tmp/tumugi_#{id}.txt") }
  run do
    log 'task3#run'
    File.write(output.path, 'done')
  end
end

task :task4 do
  output Tumugi::FileTarget.new("/tmp/tumugi_#{id}.txt")
  run do
    log 'task4#run'
    File.write(output.path, 'done')
  end
end
