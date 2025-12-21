require 'tree_stand'

module GdDoc
  class Parser
    class << self
      attr_accessor :name, :extensions, :store_raw_data

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
        targets = extensions.map{|ext| "#{GdDoc.config.project_dir_absolute}/**/*.#{ext}" }
        Dir[*targets].reject{|path|
            rel_path = relativized_path(path)
            return true if rel_path.directory?
            GdDoc.config.ignoring_paths.any?{|str| rel_path.to_s.start_with? str }
          }
      end

      def relativized_path(path)
        Pathname(path).realpath.relative_path_from(GdDoc.config.project_dir_absolute)
      end
    end

    include TreeNodeHelper

    attr_accessor(
      :file,
      :path,
      :raw_data,
    )

    def initialize(file)
      print("Readling file: #{file}...\r") if GdDoc.config.log_verbose
      self.file = file
      self.path = "res://#{GdDoc::Parser.relativized_path(file)}"
      root = self.class.parser.parse_string(File.read(file)).root_node
      self.raw_data = root.text if self.class.store_raw_data
      initializer
      parse(root)
    end

    def initializer
      # Override this method
    end

    def parse(root)
      # Override this method
    end

    def relative_path
      path.delete_prefix 'res://'
    end
  end
end

