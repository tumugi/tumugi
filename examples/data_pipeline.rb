task :generate_data do
  output do
    Tumugi::Target::FileTarget.new("/tmp/data_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do |task|
    File.open(task.output.path, "w") do |f|
      (1..10).each do |i|
        f.puts i
      end
    end
  end
end

task :sum do
  requires :generate_data

  output do
    Tumugi::Target::FileTarget.new("/tmp/output_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do |task|
    sum = 0
    File.foreach(task.input.path) do |line|
      sum += line.to_i
    end
    File.write(task.output.path, sum)
  end
end
