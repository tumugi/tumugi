require 'tumugi/plugin/target/local_file'

task :task1 do
  requires [:task2, :task3]
  output target(:local_file, "/tmp/tumugi_#{id}.txt")
  run do
    log 'task1#run'
    output.open('w') {|f| f.puts('done') }
  end
end

task :task2 do
  requires [:task4]
  output [target(:local_file, "/tmp/tumugi_#{id}.txt")]
  run do
    log 'task2#run'
    output[0].open('w') {|f| f.puts('done') }
  end
end

task :task3 do
  requires [:task4]
  output { target(:local_file, "/tmp/tumugi_#{id}.txt") }
  run do
    log 'task3#run'
    output.open('w') {|f| f.puts('done') }
  end
end

task :task4 do
  output Tumugi::Plugin::LocalFileTarget.new("/tmp/tumugi_#{id}.txt")
  run do
    log 'task4#run'
    output.open('w') {|f| f.puts('done') }
  end
end
