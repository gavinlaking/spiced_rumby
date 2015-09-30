require 'openssl'
require 'socket'
require 'json'
require 'date'
require 'colorize'
require 'curses'
require 'io/console'
require 'logger'

require 'awesome_print'
require 'sqlite3'
require 'active_record'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

require 'spiced_gracken/version'
require 'spiced_gracken/display'
require 'spiced_gracken/display/manager'
require 'spiced_gracken/models/entry'
require 'spiced_gracken/config/hash_file'
require 'spiced_gracken/config/settings'
require 'spiced_gracken/config/active_server_list'
require 'spiced_gracken/cli'
require 'spiced_gracken/encryptor'
require 'spiced_gracken/message'

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => "dev.sqlite3"
)

ActiveRecord::Schema.define do
  unless table_exists? :entries
    create_table :entries do |table|
      table.column :alias_name, :string
      table.column :address, :string
      table.column :uid, :string
      table.column :public_key, :string
    end
  end
end

module SpicedGracken
  NAME = 'Spiced Gracken'

  Settings = Config::Settings
  ActiveServers = Config::ActiveServerList

  module_function

  def start(selected_ui)
    # select the specified interface.
    # default is Display::Bash::UI
    #
    ui = Display::Bash::UI
    if !selected_ui.blank?
      if selected_ui != 'bash'
        ui = Display::TerminalCurses::UI
      elsif selected_ui == 'null'
        ui = Display::Null::UI
      end
    end

    @@display = Display::Manager.new(ui)
    @@display.start do
      CLI.check_startup_settings
    end
  end

  def ui
    @@display
  end
end
