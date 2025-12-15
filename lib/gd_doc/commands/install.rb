module GdDoc::Commands
  class Install < Dry::CLI::Command
    desc 'Intall doc directory'

    argument :directory, desc: 'Directory to install'

    example [
      '.    # Install doc to current directory',
      'doc  # Install doc to doc directory',
    ]

    def call(*)
      puts 'TODO'
    end
  end
end

