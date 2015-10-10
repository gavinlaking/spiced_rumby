module SpicedGracken
  class CLI
    class Whisper < CLI::Command
      def target
        # get first arg
        command
      end

      def message
        command_args[1..command_args.length].try(:join, ' ')
      end

      def handle
        server = ActiveServers.find(alias_name: target)

        if server
          m = Message::Whisper.new(
            message: message,
            to: target
          )

          Display.whisper m.display
          data = m.render

          Http::Client.send_to_and_close(
            location: server.location,
            payload: data,
            encrypt_with: server.public_key
          )
        else
          Display.alert "server for #{target} not found or is not online"
        end
      end
    end
  end
end
