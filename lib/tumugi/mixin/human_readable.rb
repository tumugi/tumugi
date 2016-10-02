module Tumugi
  module Mixin
    module HumanReadable
      def human_readable_time(seconds)
        [[60, :s], [60, :m], [10000, :h]].map{|count, name|
          if seconds > 0
            seconds, n = seconds.divmod(count)
            "#{sprintf('%02d', n)}"
          else
            '00'
          end
        }.compact.reverse.join(':')
      end
    end
  end
end
