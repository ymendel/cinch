dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include? dir

require 'ostruct'
require 'optparse'
require 'singleton'

require 'cinch/irc'
require 'cinch/rules'
require 'cinch/plugin'
require 'cinch/base'

module Cinch
  VERSION = '0.3.1'

  class << self

    # Setup bot options and return a new Cinch::Base instance
    def setup(ops={}, &blk)
      Cinch::Base.new(ops, &blk)
    end
    alias_method :configure, :setup
  end

end

