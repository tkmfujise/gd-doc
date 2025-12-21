module GdDoc::Commands
  class Update < Dry::CLI::Command
    desc 'Update docs'

    #
    # rm -r doc/content/scenes
    # rm -r doc/content/scripts
    # rm -r doc/content/resources
    # generate doc/content/index.adoc
    # generate doc/content/scenes/scene_name.adoc
    # generate doc/content/scripts/script_name.adoc
    # generate doc/content/resources/resource_name.adoc
    #
    def call(*)
      load_config_file
      validate_configuration
      rm_content_dir 'scenes'
      rm_content_dir 'scripts'
      rm_content_dir 'resources'
      composer = GdDoc::Composer.new
      composer.format(GdDoc::Formatter::AsciiDoc) do |formatter|
        path = Pathname(formatter.file_path)
        unless path.dirname.exist?
          mkdir_p path.dirname
        end
        write path, formatter.format
      end
    end

    private
      def validate_configuration
        if GdDoc::Project.files.none?
          STDERR.puts <<~TEXT
            ---
            Error: Missing `project.godot` file at #{GdDoc.config.project_dir}
            Please check and configure the `project_dir` in config.rb.
            ---
          TEXT
          exit(1)
        end
      end

      def rm_content_dir(name)
        dir = File.join(GdDoc.config.doc_dir, 'content', name)
        if Dir.exist?(dir)
          rm_r dir
        end
      end
  end
end


