task :generate_data do
  output do
    target(:file, "/tmp/tumugi_data_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do
    File.open(output.path, "w") do |f|
      (1..10).each do |i|
        f.puts i
      end
    end
  end
end

task :sum do
  requires :generate_data

  output do
    target(:file, "/tmp/tumugi_output_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do
    sum = 0
    File.foreach(input.path) do |line|
      sum += line.to_i
    end
    File.write(output.path, sum)
  end
end
