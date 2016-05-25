class FileTask < Tumugi::Task
  Tumugi::Plugin.register_task(:local_file, self)

  def output
    target(:local_file, "tmp/tumugi_#{self.id}.txt")
  end

  def run
    log 'sleep 2 seconds'
    sleep 2
    output.open('w') {|f| f.puts('done') }
  end
end

task :task1, type: :local_file do
  requires (1..10).map {|i| :"task2_#{i}"}
end

(1..10).each do |i|
  task :"task2_#{i}", type: :local_file do
    requires [:task3]
  end
end

task :task3, type: :local_file do
end
