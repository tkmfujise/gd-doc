module GdDoc
  class Resource < Parser
    self.name = 'godot-resource'
    self.extensions = ['tres']

    attr_accessor(
      :uid,
      :type,
      :sections,
    )

    def initializer
      self.sections = []
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          self.sections << TreeNode::Section.new(child)
        end
      end

      self.uid = value_of('gd_resource', 'uid')
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end
  end
end
