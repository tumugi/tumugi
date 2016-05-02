module Tumugi
  class Registry
    DEFAULT_PLUGIN_PATH = File.expand_path('plugin', __FILE__)

    def initialize(kind, search_prefix)
      @kind = kind
      @search_prefix = search_prefix
      @map = {}
      @paths = [DEFAULT_PLUGIN_PATH]
    end

    attr_reader :kind, :paths

    def register(type, value)
      type = type.to_sym
      @map[type] = value
    end

    def lookup(type)
      t = type.to_sym
      return @map[t] if @map.has_key?(t)
      search(type)
      return @map[t] if @map.has_key?(t)
      raise "Unknown #{@kind} plugin '#{type}'"
    end

    def search(type)
      path = "#{@search_prefix}#{type}"

      # prefer LOAD_PATH than gems
      [@paths, $LOAD_PATH].each do |paths|
        files = paths.map { |lp|
          lpath = File.expand_path(File.join(lp, "#{path}.rb"))
          File.exist?(lpath) ? lpath : nil
        }.compact
        unless files.empty?
          require files.sort.last
          return
        end
      end

      specs = Gem::Specification.find_all { |spec|
        spec.contains_requirable_file? path
      }

      # prefer newer version
      specs = specs.sort_by { |spec| spec.version }
      if spec = specs.last
        spec.require_paths.each do |lib|
          file = "#{spec.full_gem_path}/#{lib}/#{path}"
          return file
        end
      end
    end
  end
end
