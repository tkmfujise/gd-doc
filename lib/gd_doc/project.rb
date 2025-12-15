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
          self.sections << TreeNode::Section.new(child)
        when :property
          self.properties << TreeNode::Property.new(child)
        end
      end
    end

    def name
      value_of('application', 'config/name')
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end
  end
end
