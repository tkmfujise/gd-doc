module GdDoc
  module Formatter
    class AsciiDoc::Scene::Animation
      include Helper
      attr_accessor :animation, :track_aliases

      def initialize(animation)
        self.animation = animation
        self.track_aliases = Hash.new
      end

      def format
        <<~ASCIIDOC
        ==== #{animation.name || animation.id}#{ animation.autoplay ? ' (autoplay)' : '' }

        [plantuml]
        ....
        control "Root" as R
        #{animation.tracks.map.with_index{|t, i| track_definition(t, i) }.join('')}

        #{animation.loop ? 'loop' : ''}
        #{timeline}
        #{animation.loop ? 'end' : ''}
        ....
        ---
        ASCIIDOC
      end


      private
        # e.g.)
        #
        #   participant "Title\n/ButtonContainer" as T1
        #
        def track_definition(track, i)
          if track.root_node?
            ''
          else
            return '' if track_aliases[track.node_path]
            short = "T#{i}"
            self.track_aliases[track.node_path] = short
            name  = '$' + track.node_path.gsub('/', "\\n/")
            color = track.node ? node_color(track.node) : ''
            "participant \"#{name}\" as #{short} #{color}\n"
          end
        end

        # e.g.)
        #
        #   == Time: 0.0 ==
        #   Root -> T1 : position \\n = Vector2(150, 25)
        #
        def timeline
          txt = ''
          animation.time_grouped_tracks.sort_by(&:first).each do |time, arr|
            txt << "== Time: #{time} ==\n"
            arr.each do |value, track|
              txt << "R #{arrow_of(track)} #{track_alias_of(track)} : "
              txt << \
                if track.keys[:method]
                  "#{track.keys[:method]}(#{value})\n"
                else
                  "#{track.property}\\n = #{value}\n"
                end
            end
          end
          txt
        end

        def track_alias_of(track)
          if track.root_node?
            'R'
          else
            track_aliases[track.node_path]
          end
        end

        def arrow_of(track)
          if track.linear?
            ' -> '
          else
            ' ->o '
          end
        end

        def node_color(node)
          if node.type_2d?
            '#87CEFA'  # lightskyblue
          elsif node.type_3d?
            '#FFC0CB'  # pink
          elsif node.type_control?
            '#90EE90'  # lightgreen
          else
            if node.type.nil? || node.type == 'Node'
              '#A9A9A9'  # darkgray
            else
              '#FFFF00'  # yellow
            end
          end
        end
    end
  end
end
