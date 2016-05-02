class FileTask < Tumugi::Task
  Tumugi::Plugin.register_task(:file, self)

  def output
    target(:local_file, "/tmp/#{id}.txt")
  end

  def run
    log "#{id}#run"
    output.open('w') do |f|
      f.puts('done')
    end
  end
end

# Task type can specified by task plugin ID
task :task1, type: :file do
  requires [:task2, :task3]
end

task :task2, type: :file do
  requires [:task4]
end

# You can also specify type by Class object
task :task3, type: FileTask do
  requires [:task4]
end

task :task4, type: FileTask do
end
