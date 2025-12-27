module GdDoc
  class Resource < Parser
    self.name = 'godot-resource'
    self.extensions = ['tres']

    attr_accessor(
      :uid,
      :type,
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
          section = TreeNode::Section.new(child)
          self.sections << section

          case section.name
          when 'gd_resource'
            self.uid  = section.value_of('uid')
            self.type = section.value_of('script_class') || section.value_of('type')
          end

          if section.script?
            self.script_path ||= section.script_path
          end
        end
      end
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end
  end
end
