task :task1 do
  run do
    log 'task1#run'
    log "config section example['key']=#{Tumugi.config.section('example')['key']}"
  end
end
