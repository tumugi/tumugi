module Tumugi
  class Target
    def exist?
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end
  end
end
