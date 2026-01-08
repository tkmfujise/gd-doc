module GdDoc
  class Scene::Node
    attr_accessor(
      :name,
      :type,
      :parent,
      :instance,
      :scene,
      :scene_uid,
      :section,
      :children,
      :script_path,
      :script_id,
      :script,
      :ext_resources,
      :sub_resources,
    )

    def initialize(section)
      self.section  = section
      self.name     = section.attribute_value_of('name')
      self.type     = section.attribute_value_of('type')
      self.parent   = section.attribute_value_of('parent')
      self.instance = section.attribute_value_of('instance')&.id
      self.children = []
      self.ext_resources = []
      self.sub_resources = []
      build_resources
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

    def set_script_path(script_path_ids)
      return unless script_id
      self.script_path = script_path_ids[script_id]
    end

    def script=(script)
      res = ext_resources.find{|r| r.name == 'script' }
      if res
        res.instance = script
      end
      @script = script
    end

    def scene=(scene)
      if scene
        self.type = scene.root_node&.type
        self.script ||= scene.script
      end
      @scene = scene
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

    private
      def build_resources
        section.properties.each do |prop|
          case prop.value
          when GdDoc::TreeNode::ExtResource
            self.ext_resources << prop.value.tap{|p| p.name = prop.name }
            case prop.name
            when 'script'
              self.script_id = prop.value.id
            end
          when GdDoc::TreeNode::SubResource
            self.sub_resources << prop.value.tap{|p| p.name = prop.name }
          end
        end
      end
  end
end
