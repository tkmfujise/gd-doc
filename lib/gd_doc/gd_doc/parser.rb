require 'tree_stand'

module GdDoc
  class Parser
    class << self
      attr_accessor :name, :extensions
    end
    
    def self.parser
      TreeStand::Parser.new(self.name)
    end

    def self.files
      Dir["#{GdDoc.config.project_dir}/**/*.#{self.extensions.join('|')}"]
    end

    include TreeNodeHelper

    attr_accessor(
      :file,
      :root,
    )

    def initialize(file)
      self.file = file
      self.root = self.class.parser.parse_string(File.read(file)).root_node
      initializer
      parse(root)
    end

    def initializer
      # Override this method
    end

    def parse(root)
      # Override this method
    end
  end
end

