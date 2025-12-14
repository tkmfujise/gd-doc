
module GdDoc
  class Configuration
    attr_accessor :project_dir

    def initialize
      self.project_dir = 'demo'
    end
  end
end
