module GdDoc
  module Formatter
    class AsciiDoc::Scene::Animation
      attr_accessor :animation, :track_aliases

      def initialize(animation)
        self.animation = animation
        self.track_aliases = Hash.new
      end

      def format
        <<~ASCIIDOC
        ==== #{animation.name || animation.id}

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
            return '' if track_aliases[track.node]
            short = "T#{i}"
            self.track_aliases[track.node] = short
            name  = '$' + track.node.gsub('/', "\\n/")
            "participant \"#{name}\" as #{short}\n"
          end
        end

        # e.g.)
        #
        #   == Time: 0.0 ==
        #   Root -> T1 : position \\n = Vector2(150, 25)
        #
        def timeline
          txt = ''
          animation.time_grouped_tracks.sort.each do |time, arr|
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
            track_aliases[track.node]
          end
        end

        def arrow_of(track)
          if track.linear?
            ' -> '
          else
            ' ->o '
          end
        end
    end
  end
end
