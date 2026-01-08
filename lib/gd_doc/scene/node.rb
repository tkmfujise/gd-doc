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
    )

    def initialize(section)
      self.section  = section
      self.name     = section.attribute_value_of('name')
      self.type     = section.attribute_value_of('type')
      self.parent   = section.attribute_value_of('parent')
      self.instance = section.attribute_value_of('instance')&.value
      self.script_id = section.property_value_of('script')&.value
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

    def set_script_path(script_path_ids)
      return unless script_id
      self.script_path = script_path_ids[script_id]
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
  end
end

