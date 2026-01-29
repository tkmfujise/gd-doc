module GdDoc
  class Configuration
    DEFAULT_DOC_DIR = 'gd_doc'

    attr_accessor(
      :project_dir,
      :doc_dir,
      :log_verbose,
      :ignoring_paths,
      :asset_text_extensions,
    )

    def initialize
      self.project_dir = 'demo/complex'
      self.doc_dir = File.join(project_dir, DEFAULT_DOC_DIR)
      self.ignoring_paths = [
        'addons',
        'test',
        'tmp',
      ]
      self.asset_text_extensions = %w[txt rb json po sh bat csv gdshader]
    end

    def project_dir_absolute
      Pathname(project_dir).realpath
    end
  end
end
