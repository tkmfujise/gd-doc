require 'pry'

module GdDoc::Commands
  class Repl < Dry::CLI::Command
    desc 'Start REPL'

    def call(*)
      Pry.start
    end
  end
end

