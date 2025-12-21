module GdDoc::Commands
  class Install < Dry::CLI::Command
    desc 'Install docs'

    argument :directory, desc: 'Directory to install'

    example [
      "     # Install docs to `#{GdDoc::Configuration::DEFAULT_DOC_DIR}` directory",
      '.    # Install docs to current directory',
      'doc  # Install docs to `doc` directory',
    ]

    #
    # cp -r templates doc
    # generate doc/config.rb
    #
    def call(directory: GdDoc::Configuration::DEFAULT_DOC_DIR, **)
      GdDoc.config.log_verbose = true
      confirm_override(directory)
      cp_r templates_dir, directory
      puts <<~TEXT
        Next steps:
        ---------------------
        $ cd #{directory}
        $ rake
        ---------------------
      TEXT
    end

    private
      def confirm_override(directory)
        if Dir.exist? directory
          yes? "Override direcotry #{directory}?"
          rm_r directory
        end
      end
  end
end

