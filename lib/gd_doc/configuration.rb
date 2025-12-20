module GdDoc
  class Configuration
    DEFAULT_DOC_DIR = 'gd_doc'

    attr_accessor(
      :project_dir,
      :doc_dir,
      :log_verbose,
      :ignoring_paths,
    )

    def initialize
      # self.project_dir = 'demo'
      self.project_dir = '/mnt/d/Documents/Imitations/Game/Platformer_Celeste/GodotApp'
      self.doc_dir = File.join(project_dir, DEFAULT_DOC_DIR)
      self.ignoring_paths = [
        'addons',
        'test',
        'tmp',
      ]
    end
  end
end
