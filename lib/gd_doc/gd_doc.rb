require 'tree_stand'
require 'zeitwerk'

module GdDoc
  ROOT_DIR = File.expand_path('../..', __dir__)
  TREE_SITTER_DIR = Pathname("#{ROOT_DIR}/tree-sitters")

  class << self
    def configure(&block)
      yield config
    end

    def config
      @_config ||= Configuration.new
    end

    def loader
      @_loader = begin
        Zeitwerk::Loader.for_gem.tap do |loader|
          loader.enable_reloading
        end
      end
    end
  end
end


TreeStand.configure do
  config.parser_path = GdDoc::TREE_SITTER_DIR
end


GdDoc.loader.setup

def reload!
  GdDoc.loader.reload
end
