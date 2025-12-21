module GdDoc
  class Scene < Parser
    self.name = 'godot-resource'
    self.extensions = ['tscn']

    class Node
      attr_accessor(
        :name,
        :type,
        :parent,
        :instance,
        :scene,
        :section,
        :children,
      )

      def initialize(section)
        self.section  = section
        self.name     = section.attribute_value_of('name')
        self.type     = section.attribute_value_of('type')
        self.parent   = section.attribute_value_of('parent')
        self.instance = section.attribute_value_of('instance') \
          &.arguments&.first&.value
        self.children = []
      end

      def root?
        parent == nil
      end

      def root_child?
        parent == '.'
      end

      def path
        if root?
          '.'
        elsif root_child?
          name
        else
          "#{parent}/#{name}"
        end
      end

      def depth
        if root?
          0
        elsif root_child?
          1
        else
          2 + parent.count('/')
        end
      end

      def type_2d?
        type && type.end_with?('2D')
      end

      def type_3d?
        type && type.end_with?('3D')
      end

      def type_control?
        type && Type::CONTROLS.include?(type)
      end

      def tree
        [self, *children.map(&:tree)]
      end

      def inspect
        <<~RUBY
          <GdDoc::Scene::Node "#{path}" <"#{type}">>
        RUBY
      end
    end


    attr_accessor(
      :uid,
      :script_path,
      :script,
      :sections,
      :root_node,
      :child_nodes,
    )

    def initializer
      self.sections = []
      self.child_nodes = []
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          self.sections << TreeNode::Section.new(child)
        end
      end

      self.uid = value_of('gd_scene', 'uid')
      self.script_path = sections.map(&:script_path).compact[0]
      build_nodes
    end

    def nodes
      [root_node, *child_nodes]
    end

    def tree
      [root_node, child_nodes.select(&:root_child?).map(&:tree)]
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end

      def build_nodes
        self.root_node   = Node.new(sections.find(&:root_node?))
        self.child_nodes = sections.select(&:child_node?) \
          .map{|section| Node.new(section) }

        child_nodes.each do |node|
          target = nodes.find{|n| n.path == node.parent }
          target.children << node if target
        end
      end
  end
end

