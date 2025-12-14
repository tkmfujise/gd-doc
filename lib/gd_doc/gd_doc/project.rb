module GdDoc
  class Project < Parser
    self.name = 'godot-resource'
    self.extensions = ['godot']

    attr_accessor(
      :properties,
      :sections,
    )

    def initializer
      self.properties = []
      self.sections   = []
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          self.sections << Section.new(child)
        when :property
          self.properties << Property.new(child)
        end
      end
    end
  end
end
