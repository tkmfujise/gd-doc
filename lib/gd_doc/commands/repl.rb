require 'pry'

module GdDoc::Commands
  class Repl < Dry::CLI::Command
    desc 'Start REPL'

    def call(*)
      load_config_file
      Pry.start
    end
  end
end

