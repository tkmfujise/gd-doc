require 'tree_sitter'

module GDDoc
  ROOT_DIR = File.expand_path('../..', __dir__)
  TREE_SITTER_DIR = Pathname("#{ROOT_DIR}/tree-sitter-gdscript")

  class << self
    def platform_linux?
      RbConfig::CONFIG['host_os'].include? 'linux'
    end

    def platform_macos?
      RbConfig::CONFIG['host_os'].include? 'darwin'
    end

    def language
      @lanuage ||=TreeSitter::Language.load('gdscript', gdscript_tree_sitter_path)
    end

    def gdscript_tree_sitter_path
      ext = \
        if platform_linux?
          'so'
        elsif platform_macos?
          'dylib'
        else
          raise 'Unsupported platform. Linux/macOS only supported.'
        end

      TREE_SITTER_DIR.join("gdscript.#{ext}")
    end


    def parse
      src = <<~GDSCRIPT
        extends Node
        class_name Foo

        signal foo_changed
        var foo := 1
        @export bar : bool

        func _ready() -> void:
            pass
      GDSCRIPT

      parser = TreeSitter::Parser.new
      parser.language = language

      tree = parser.parse_string(nil, src)
      root = tree.root_node
    end
  end
end
