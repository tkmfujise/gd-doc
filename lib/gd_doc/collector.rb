module GdDoc
  class Collector
    class << self
      attr_accessor :extensions

      def build
        new(files[0])
      end

      def build_all
        files.map{|file| new(file) }
      end

      def files
        targets = extensions.map{|ext| "#{GdDoc.config.project_dir_absolute}/**/*.#{ext}" }
        Dir[*targets].reject{|path|
            next true if File.directory?(path)
            rel_path = relativized_path(path)
            GdDoc.config.ignoring_paths.any?{|str| rel_path.to_s.start_with? str }
          }
      end

      def relativized_path(path)
        Pathname(path).realpath.relative_path_from(GdDoc.config.project_dir_absolute)
      end
    end


    attr_accessor :file, :path


    def initialize(file)
      print("Readling file: #{file}...\r") if GdDoc.config.log_verbose
      self.file = file
      self.path = "res://#{GdDoc::Parser.relativized_path(file)}"
      initializer
    end

    def initializer
      # Override this method
    end

    def relative_path
      path.delete_prefix 'res://'
    end
  end
end


