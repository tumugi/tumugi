require 'tumugi/target/file_target'

class FileTask < Tumugi::Task
  def output
    Tumugi::Target::FileTarget.new("/tmp/tumugi_#{self.id}.txt")
  end

  def run
    @logger.info "#{self.id}#run"
    sleep 5
    File.write(output.path, 'done')
    @logger.info "#{self.id}#done"
  end
end

task :task1, type: FileTask do
  requires (1..10).map {|i| :"task2_#{i}"}
end

(1..10).each do |i|
  task :"task2_#{i}", type: FileTask do
    requires [:task3]
  end
end

task :task3, type: FileTask do
end
