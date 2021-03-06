module Cinch
  module Names
    attr_reader :channel_names
    
    def tracking_names?
      !!@tracking_names
    end
    
    def track_names
      return if tracking_names?
      
      @tracking_names = true
      
      @channel_names = {}
      
      on(:join) do |m|
        if m.nick == nick
          names(m.channel)
        else
          channel_names[m.channel] ||= []
          channel_names[m.channel].push m.nick
        end
      end
      
      on(353) do |m|
        channel = m.params.detect { |c|  c.match(/^#/) }
        names   = m.text.split.collect { |n|  n.sub(/^@/, '') }
        channel_names[channel] ||= []
        channel_names[channel] += names
      end
      
      on(:part) do |m|
        if m.nick == nick
          channel_names.delete(m.channel)
        else
          channel_names[m.channel] ||= []
          channel_names[m.channel].delete m.nick
        end
      end
      
      on(:quit, :kill) do |m|
        channel_names.each_value { |names|  names.delete m.nick }
      end
      
      on(:nick) do |m|
        channel_names.each_value { |names|  names.push m.recipient if names.delete m.nick }
      end
    end
  end
end

class Cinch::Base
  include Cinch::Names
end
