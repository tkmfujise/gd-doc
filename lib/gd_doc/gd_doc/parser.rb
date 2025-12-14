require 'tree_stand'

module GdDoc
  class Parser
    class << self
      attr_accessor :name, :extensions

      def build
        new(files[0])
      end

      def build_all
        files.map{|file| new(file) }
      end

      def parser
        TreeStand::Parser.new(name)
      end

      def files
        Dir["#{GdDoc.config.project_dir}/**/*.#{extensions.join('|')}"]
      end
    end

    include TreeNodeHelper

    attr_accessor(
      :file,
      :path,
    )

    def initialize(file)
      self.file = file
      self.path = "res://#{Pathname(file).relative_path_from(GdDoc.config.project_dir)}"
      root = self.class.parser.parse_string(File.read(file)).root_node
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

