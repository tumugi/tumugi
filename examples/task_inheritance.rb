class FileTask < Tumugi::Task
  def output
    Tumugi::Target::FileTarget.new("/tmp/#{self.id}.txt")
  end

  def run
    puts "#{self.id}#run"
    File.write(output.path, 'done')
  end
end

task :task1, type: FileTask do
  requires [:task2, :task3]
end

task :task2, type: FileTask do
  requires [:task4]
end

task :task3, type: FileTask do
  requires [:task4]
end

task :task4, type: FileTask do
end
