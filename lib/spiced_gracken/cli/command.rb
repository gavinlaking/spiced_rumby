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
          CLI::Ping.new(_input, cli: _cli).handle
        when WHO
          SpicedGracken.ui.info(SpicedGracken.active_server_list.who)
        when STOP_LISTENING
          _cli.close_server
        when SERVERS, SERVER
          CLI::Server.new(_input, cli: _cli).handle
        when CONFIG
          CLI::Config.new(_input, cli: _cli).handle
        when EXIT, QUIT
          _cli.shutdown
        when LISTEN
          _cli.start_server
        when CONNECT, CHAT
          SpicedGracken.ui.alert('not implemented...')
        else
          SpicedGracken.ui.alert('not implemented...')
        end
      end

      protected

      def command_string
        _input[1, _input.length]
      end

      def command_args
        command_string.split(' ')
      end

      def command
        command_args.first
      end

      def sub_command_args
        command_args[2..3]
      end

      private

      def sub_command
        command_args[1]
      end
    end
  end
end
