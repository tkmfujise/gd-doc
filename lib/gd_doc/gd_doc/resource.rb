module GdDoc
  class Resource < Parser
    self.name = 'godot-resource'
    self.extensions = ['tscn']

    attr_accessor(
      :uid,
      :sections,
    )

    def initializer
      self.sections = []
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          self.sections << Section.new(child)
        end
      end
    end
  end
end
