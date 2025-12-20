module GdDoc::Commands
  extend Dry::CLI::Registry
  Dry::CLI::Command.include Helper

  register 'install', Install
  register 'update',  Update
  register 'repl',    Repl
end
