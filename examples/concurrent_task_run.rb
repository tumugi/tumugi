class FileTask < Tumugi::Task
  Tumugi::Plugin.register_task(:file, self)

  def output
    target(:file, "/tmp/tumugi_#{self.id}.txt")
  end

  def run
    log 'sleep 2 seconds'
    sleep 2
    File.write(output.path, 'done')
  end
end

task :task1, type: :file do
  requires (1..10).map {|i| :"task2_#{i}"}
end

(1..10).each do |i|
  task :"task2_#{i}", type: :file do
    requires [:task3]
  end
end

task :task3, type: :file do
end
