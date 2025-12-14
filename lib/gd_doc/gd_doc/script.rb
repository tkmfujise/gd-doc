require 'tree_stand'

module GdDoc
  class Script < Parser
    self.name = 'gdscript'
    self.extensions = ['gd']

    attr_accessor(
      :extends,
    )

    def parse
      root.each do |child|
        case child.type
        when :extends_statement
          self.extends = dig(child, :type, :identifier)&.text
        end
      end
    end
  end
end
