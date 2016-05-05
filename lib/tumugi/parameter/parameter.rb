module Tumugi
  module Parameter
    class Parameter
      attr_accessor :name

      def initialize(name, opts={})
        @name = name
        @opts = opts
      end

      def get
        if auto_bind?
          # TODO: implement find auto binding value
        end
        default_value
      end

      def auto_bind?
        @opts[:auto_bind].nil? ? true : @opts[:auto_bind]
      end

      def required?
        @opts[:required].nil? ? false : @opts[:required]
      end

      def type
        @opts[:type] || :string
      end

      def default_value
        @opts[:default] || nil
      end
    end
  end
end
