
module GdDoc
  class Configuration
    attr_accessor :project_dir, :doc_dir

    def initialize
      # self.project_dir = 'demo'
      self.project_dir = '/mnt/d/Documents/Imitations/Game/Platformer_Celeste/GodotApp'
      self.doc_dir = File.join(project_dir, 'gd_doc')
    end
  end
end
