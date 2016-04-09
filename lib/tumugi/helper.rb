module Tumugi
  module Helper
    def list(obj)
      if obj.nil?
        []
      elsif obj.is_a?(Array)
        obj
      elsif obj.is_a?(Hash)
        obj.map { |k,v| v }
      else
        [obj]
      end
    end
  end
end
