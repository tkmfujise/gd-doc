module GdDoc
  class Scene::Animation
    class Track
      attr_accessor(
        :order,
        :type,
        :keys,
        :imported,
        :enabled,
        :node_path,
        :node,
        :property,
        :interp,
        :loop_wrap,
      )

      def initialize(scene, order, properties)
        self.order = order
        properties.each do |prop|
          key = prop.name.split('/').last
          if respond_to?("#{key}=")
            public_send("#{key}=", prop.value)
          end
        end
        self.node = scene.find(node_path) if node_path
      end

      def path=(value)
        path = \
          case value
          when GdDoc::TreeNode::Constructor
            value.arguments[0]&.value || ''
          when GdDoc::TreeNode::NodePath
            value.value
          else
            value
          end

        self.node_path, self.property = path.split(':')
      end

      def path
        "#{node_path}:#{property}"
      end

      def root_node?
        node_path == '.'
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
      :autoplay,
      :step,
      :tracks,
    )

    def initialize(scene, section)
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
          tracks << Track.new(scene, key[1].to_i, arr) if key[0] == 'tracks'
        end
      end
    end


    # { 0.0 => ['value', track] }
    def time_grouped_tracks
      grouped = Hash.new
      tracks.reject{|t| t.type == 'audio' }.each do |track|
        track.keys[:times].each_with_index do |time, i|
          next unless track.keys[:values]
          grouped[time] ||= []
          grouped[time] << [track.keys[:values][i], track]
        end
      end
      grouped
    end
  end
end

