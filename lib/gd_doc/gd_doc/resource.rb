module GdDoc
  class Resource < Parser
    self.name = 'godot-resource'
    self.extensions = ['tscn']

    attr_accessor(
      :uid,
      :script_path,
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

      self.uid = value_of('gd_scene', 'uid')
      self.script_path = sections.map(&:script_path).compact[0]
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end
  end
end
