module GdDoc::Commands
  class Upgrade < Dry::CLI::Command
    desc 'Upgrade gd-doc'

    def call(*)
      cd GdDoc::ROOT_DIR do
        sh 'git reset --hard'
        sh 'git pull'
        sh 'git submodule update --init --recursive'
        sh 'bundle install'
        sh 'rake build'
      end
    end
  end
end

