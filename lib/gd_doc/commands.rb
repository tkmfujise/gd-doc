module GdDoc::Commands
  extend Dry::CLI::Registry

  register 'install', Install
end
