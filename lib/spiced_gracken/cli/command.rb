module SpicedGracken
  class CLI
    class Command < CLI::Input
      attr_accessor :_input

      # Commands
      SET = 'set'
      CONFIG = 'config'
      DISPLAY = 'display'
      EXIT = 'exit'
      QUIT = 'quit'
      LISTEN = 'listen'
      STOP_LISTENING = 'stoplistening'
      CONNECT = 'connect'
      CHAT = 'chat'
      ADD = 'add'
      REMOVE = 'remove'
      RM = 'rm'
      SERVERS = 'servers'
      SERVER = 'server'
      WHO = 'who'
      PING = 'ping'

      def handle
        # these could even be split up in to classes if they needed to be
        case command
        when PING
          CLI::Ping.new(_input).handle
        when WHO
          Display.info(ActiveServers.who)
        when STOP_LISTENING
          CLI.close_server
        when SERVERS, SERVER
          CLI::Server.new(_input).handle
        when CONFIG
          CLI::Config.new(_input).handle
        when EXIT, QUIT
          CLI.shutdown
        when LISTEN
          CLI.start_server
        else
          Display.alert('not implemented...')
        end
      end

      protected

      def command_string
        @command_string ||= _input[1, _input.length]
      end

      def command_args
        @command_args ||= command_string.split(' ')
      end

      def command
        @command ||= command_args.first
      end

      def sub_command_args
        @sub_command_args ||= command_args[2..3]
      end

      def sub_command
        @sub_command ||= command_args[1]
      end
    end
  end
end
