module GdDoc::Commands
  class Upgrade < Dry::CLI::Command
    desc 'Upgrade gd-doc'

    def call(*)
      cd GdDoc::ROOT_DIR do
        sh 'git pull'
        sh 'git submodule update --init --recursive'
      end
    end
  end
end

