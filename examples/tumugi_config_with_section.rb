Tumugi.configure do |config|
  config.max_retry = 3
  config.retry_interval = 1

  config.section('example') do |section|
    section.key = 'value'
  end
end
