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
        :scene_uid,
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

      def scene=(scene)
        if scene
          self.type = scene.root_node&.type
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


    class Connection
      attr_accessor(
        :name,
        :from,
        :to,
        :method_name,
      )

      def initialize(section)
        self.name = section.attribute_value_of('signal')
        self.from = section.attribute_value_of('from')
        self.to   = section.attribute_value_of('to')
        self.method_name = section.attribute_value_of('method')
      end
    end


    class Animation
      class Track
        attr_accessor(
          :order,
          :type,
          :keys,
          :imported,
          :enabled,
          :node,
          :property,
          :interp,
          :loop_wrap,
        )

        def initialize(order, properties)
          self.order = order
          properties.each do |prop|
            key = prop.name.split('/').last
            if respond_to?("#{key}=")
              public_send("#{key}=", prop.value)
            end
          end
        end

        def path=(value)
          path = \
            if value.kind_of?(GdDoc::TreeNode::Constructor)
              value.arguments[0]&.value || ''
            else
              value
            end

          self.node, self.property = path.split(':')
        end

        def path
          "#{node}:#{property}"
        end

        def root_node?
          node == '.'
        end


        # == keys
        # pattern 1)
        #
        #   "{\n\"times\": PackedFloat32Array(0, 0.5),\n\"transitions\": PackedFloat32Array(0.25, 1),\n\"update\": 0,\n\"values\": [Vector2(2080, 25), Vector2(1720, 25)]\n}"
        # => {
        #   times:       [0, 0.5],
        #   transisions: [0.25, 1],
        #   update:      '0',
        #   values:      ['Vector2(2080, 25)', 'Vector2(1720, 25)'],
        # }
        #
        # patern 2)
        #
        #   "PackedFloat32Array(0, 1, 0, -1.1106, 0)"
        # => {
        #   times: [0, 0],
        #   values: [1, -1.1106],
        # }
        #

        def keys=(value)
          if value.kind_of?(Hash)
            @keys = value
          else
            @keys = Hash.new
            case value
            when GdDoc::TreeNode::Constructor
              arr = value.arguments.map(&:value)
              even, odd = arr.partition.with_index{|_, i| i.even? }
              count = [even.count, odd.count].min
              @keys = {
                times:  even.take(count),
                values: odd.take(count),
              }
            else
              value.to_s.scan(/\"(\w+)\":\s(.+)\n/).each do |k, v|
                v = v[0..-2] if v.end_with?(',')
                case k
                when 'times', 'transitions'
                  regexp  = /Packed\w+Array\((.+)\)/
                  if v =~ regexp
                    v = v[regexp, 1]&.split(', ')&.map(&:to_f)
                  else
                    v = [v.to_f]
                  end
                when 'values'
                  regexp = /[^\[\s)]+\([^\)]+\),?/
                  if v =~ regexp
                    v = v.scan(regexp).map{|s| s.dup.delete_suffix(',') }
                  else
                    v = v[1..-2].split(', ')
                  end
                end
                @keys[k.to_sym] = v
              end
            end
          end

          def linear?
            keys[:update] == '0'
          end

          def discrete?
            keys[:update] == '1'
          end
        end
      end

      attr_accessor(
        :id,
        :name,
        :length,
        :loop,
        :step,
        :tracks,
      )

      def initialize(section)
        self.id     = section.attribute_value_of('id')
        self.tracks = []
        section.properties.group_by{|p| p.name.split('/')[0..1] }.each do |key, arr|
          case key
          when ['length']
            self.length = arr[0].value
          when ['resource_name']
            self.name   = arr[0].value
          when ['loop_mode']
            self.loop   = arr[0].value == 1
          when ['step']
            self.step   = arr[0].value&.to_f
          else
            tracks << Track.new(key[1].to_i, arr) if key[0] == 'tracks'
          end
        end
      end


      # { 0.0 => ['value', track] }
      def time_grouped_tracks
        grouped = Hash.new
        tracks.reject{|t| t.type == 'audio' }.each do |track|
          track.keys[:times].each_with_index do |time, i|
            grouped[time] ||= []
            grouped[time] << [track.keys[:values][i], track]
          end
        end
        grouped
      end
    end


    attr_accessor(
      :uid,
      :script_path,
      :script,
      :sections,
      :root_node,
      :child_nodes,
      :connections,
      :animations,
    )

    def initializer
      self.sections = []
      self.child_nodes = []
      self.connections = []
      self.animations  = []
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
      end
  end
end

