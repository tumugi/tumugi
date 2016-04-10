module Tumugi
  module Target
    class Base
      def exist?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
