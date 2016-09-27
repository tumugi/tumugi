module Tumugi
  module Mixin
    module HumanReadable
      def human_readable_time(seconds)
        [[60, :second], [60, :minute], [24, :hour], [1000, :day]].map{|count, name|
          if seconds > 0
            seconds, n = seconds.divmod(count)
            "#{n.to_i} #{name}#{n.to_i > 1 ? 's' : ''}"
          end
        }.compact.reverse.join(' ')
      end
    end
  end
end
