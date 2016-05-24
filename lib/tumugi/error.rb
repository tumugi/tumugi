module Tumugi
  class TumugiError < StandardError
  end

  class ConfigError < TumugiError
  end

  class ParameterError < TumugiError
  end
end
