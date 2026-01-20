
GdDoc.configure do |config|
  # = Configure the Godot project directory
  # config.project_dir = '../' # Path to project.godot directory
  config.project_dir = '../'

  # = Configure the documentation directory to compile
  # config.doc_dir = '.' # Current directory
  config.doc_dir = '.'

  # = Configure the paths to ignore during compilation
  # config.ignoring_paths = ['addons', 'test', 'tmp']
  config.ignoring_paths = [
    'addons',
    'test',
    'tmp',
  ]

  # = Configure asset text extensions
  # config.asset_text_extensions = %w[txt rb json po sh bat csv]
  config.asset_text_extensions = %w[txt rb json po sh bat csv]
end
