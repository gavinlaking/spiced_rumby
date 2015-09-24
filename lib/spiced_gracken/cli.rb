require 'spiced_gracken/http/client'
require 'spiced_gracken/http/server'
require 'spiced_gracken/cli/input'
require 'spiced_gracken/cli/command'
require 'spiced_gracken/cli/config'
require 'spiced_gracken/cli/ping'
require 'spiced_gracken/cli/server'
require 'spiced_gracken/cli/whisper'

module SpicedGracken
  # A user interface is responsible for for creating a client
  # and sending messages to that client
  class CLI
    attr_accessor :client, :settings, :server

    def initialize(settings: nil)
      @settings = settings
      display_welcome

      check_startup_settings

      # this will allow our listener / server to print exceptions,
      # rather than  silently fail
      Thread.abort_on_exception = true
    end

    def listen_for_commands
      while @client.nil? || !@client.socket.closed?
        begin
          msg = gets
          # clean the line
          print "\r\e[K"

          handler = Input.create(
            msg,
            cli: self,
            settings: @settings)

          handler.handle

        rescue SystemExit, Interrupt
          shutdown
        rescue Exception => e
          puts e.class.name
          puts e.message.colorize(:red)
          puts e.backtrace.join("\n").colorize(:red)
        end
      end

      puts 'client not running'.colorize(:red)
    end

    def start_server
      @server = Queue.new
      # start the server thread
      Thread.new(@settings) do |settings|
        @server << Http::Server.new(port: settings['port'])
      end
    end

    def close_server
      puts 'shutting down server'
      server = @server.pop
      server.try(:server).try(:close)
      puts 'no longer listening...'
    end

    def server_address
      "#{settings['ip']}:#{settings['port']}"
    end

    def check_startup_settings
      start_server if settings['autolisten']
    end

    def display_welcome
      welcome = Help.welcome(texts: { configuration: @settings.as_hash })
      puts welcome
    end

    # save config and exit
    def shutdown
      # close_server
      puts 'saving config...'
      SpicedGracken.settings.save
      SpicedGracken.active_server_list.save
      abort "\n\nGoodbye.  "
    end
  end
end
