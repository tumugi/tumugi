Tumugi.config do |c|
  c.max_retry = 3
  c.retry_interval = 1

  c.section('example') do |s|
    s.key = 'value'
  end
end
