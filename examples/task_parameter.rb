task :task1 do
  param :key1, auto_bind: true, required: true #=> get value from CLI parameter

  requires :task2
  run do
    log "key1=#{key1}" # You can get param as task property
  end
end

task :task2 do
  param :key1
  param :key2, type: :time
  key2 Time.parse('2016-06-27')

  requires :task3
  run do
    log "key1=#{key1}"
    log "key2=#{key2}"
  end
end

task :task3 do
  param :key3, default: 'default value' #=> 'default value', get value from :default when binding value does not found

  run do
    log "key3=#{key3}"
  end
end
