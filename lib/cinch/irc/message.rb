module Cinch
  module IRC
    
    # Used by Parser#parse_servermessage
    #
    class Message

      # Message prefix
      attr_reader :prefix

      # Message command (PRIVMSG, JOIN, KICK, etc)
      attr_reader :command

      # Message params
      attr_reader :params

      # Message symbol (lowercase command, ie. :privmsg, :join, :kick)
      attr_reader :symbol
      
      # The raw string passed to ::new
      attr_reader :raw

      # Hash with message attributes
      attr_reader :data

      def initialize(raw, prefix, command, params)
        @raw = raw
        @prefix = prefix
        @command = command
        @params = params

        @symbol = command.downcase.to_sym
        @data = {}
      end

      # Access attribute
      def [](var)
        @data[var.to_sym]
      end

      # Add a new attribute (stored in @data)
      def add(var, val)
        @data[var.to_sym] = val
      end
      alias []= add

      # Remove an attribute
      def delete(var)
        var = var.to_sym
        return unless @data.key?(var)
        @data.delete(var)
      end

      # Check if our message was sent privately
      def private?
        !@data[:channel]
      end

      # Add the nick/user/host attributes
      def apply_user(nick, user, host)
        @data[:nick] = nick
        @data[:user] = user
        @data[:host] = host
      end

      # The raw IRC message
      def to_s
        raw
      end

      def method_missing(meth, *args, &blk) # :nodoc:
        if @data.key?(meth)
          @data[meth]
        else
          super
        end
      end

    end
  end
end

