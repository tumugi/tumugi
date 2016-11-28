task :generate_data do
  output do
    target(:local_file, "tmp/tumugi_data_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do
    output.open('w') do |f|
      (1..10).each do |i|
        f.puts i
      end
    end
  end
end

task :sum do
  requires :generate_data

  output do
    target(:local_file, "tmp/tumugi_output_#{Time.now.strftime('%Y-%m-%d')}.txt")
  end

  run do
    sum = 0
    input.open do |line|
      sum += line.to_i
    end
    output.open('w') { |f| f.puts(sum) }
  end
end
