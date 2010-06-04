module Cinch

  # == Description
  # 
  class Plugins
    include Singleton
    include Enumerable

    def initialize
      @list = {}
    end

    def register(plugin, klass)
      @list[plugin] = klass.new
    end

    def get(plugin)
      @list[plugin]
    end

    def proc_for(plugin)
      @list[plugin].method(:execute).to_proc
    end

    def each
      @list.each {|k, v| yield k, v }
    end

    def all
      @list
    end
  end

  # == Description
  #
  class Plugin
    class << self

      def inherited(klass)
        Plugins.instance.register(klass.to_s.downcase, klass)
      end

      def plugin
        self.to_s.downcase
      end
      
      def rule(str)
        Plugins.instance.get(plugin).rule = str
      end
    end

    attr_accessor :rule, :options, :keys, :callback

    def initialize
      # plugin options
      @rule = nil
      @options = {}
      @keys = {}
      @callback = nil
    end

  end
end
