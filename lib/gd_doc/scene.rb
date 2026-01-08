module GdDoc
  class Scene < Parser
    self.name = 'godot-resource'
    self.extensions = ['tscn']

    attr_accessor(
      :uid,
      :script,
      :sections,
      :root_node,
      :child_nodes,
      :connections,
      :animations,
      :instantiators,
      :assets,
    )

    def initializer
      self.sections = []
      self.child_nodes = []
      self.connections = []
      self.animations  = []
      self.instantiators = Set.new
      self.assets = Set.new
    end

    def parse(root)
      root.children.each do |child|
        case child.type
        when :section
          self.sections << TreeNode::Section.new(child)
        end
      end

      self.uid = value_of('gd_scene', 'uid')
      script_path_ids = sections.select(&:script?).map{|s|
          [s.attribute_value_of('id'), s.script_path]
        }.to_h
      build_nodes(script_path_ids)
      build_connections
      build_animations
    end

    def nodes
      [root_node, *child_nodes]
    end

    def tree
      [root_node, child_nodes.select(&:root_child?).map(&:tree)]
    end

    def find(path)
      nodes.find{|n| n.path == path }
    end

    def script_paths
      nodes.map(&:script_path).compact
    end

    def script
      root_node&.script
    end

    def combine_scripts(scripts_hash)
      nodes.select(&:script_path).each do |node|
        script = scripts_hash[node.script_path]
        next unless script
        node.script = script
        if node.root?
          script.attached_scenes << self
        end
      end
    end

    def combine_assets(assets_hash)
      sections.select(&:ext_resource?).each do |section|
        path  = section.attribute_value_of('path')
        asset = assets_hash[path]
        if asset
          self.assets << asset
          asset.attached_scenes << self
        end
      end
    end

    private
      def value_of(section_name, property_name)
        section = sections.find{|s| s.name == section_name }
        return nil unless section
        section.value_of(property_name)
      end

      def build_nodes(script_path_ids)
        self.root_node   = Node.new(sections.find(&:root_node?))
        self.child_nodes = sections.select(&:child_node?) \
          .map{|section| Node.new(section) }

        root_node.set_script_path(script_path_ids)
        child_nodes.each do |node|
          target = nodes.find{|n| n.path == node.parent }
          node.set_script_path(script_path_ids)
          target.children << node if target
        end
        root_node.scene = self
        set_uid_to_nodes
      end

      def set_uid_to_nodes
        ext_resources = sections.select(&:ext_resource?)
        child_nodes.select(&:instance).each do |node|
          section = ext_resources \
            .find{|e| e.attribute_value_of('id') == node.instance }
          if section
            node.scene_uid = section.attribute_value_of('uid')
          end
        end
      end

      def build_connections
        self.connections = sections.select(&:connection_signal?) \
          .map{|section| Connection.new(section) }
      end

      def build_animations
        self.animations = sections.select(&:animation?) \
          .map{|section| Animation.new(section) }

        player = nodes.find{|n| n.type == 'AnimationPlayer' }
        if player
          name = player.section.value_of('autoplay')
          return unless name
          animations.find{|a| a.name == name }&.then{|a| a.autoplay = true }
        end
      end
  end
end
