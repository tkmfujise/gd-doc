require 'tree_stand'

module GdDoc
  class Resource < Parser
    self.name = 'godot-resource'
    self.extensions = ['tscn']
  end
end
