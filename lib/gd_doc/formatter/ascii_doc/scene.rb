module GdDoc
  module Formatter
    class AsciiDoc::Scene < Base
      attr_accessor :scene

      def initialize(scene)
        self.scene = scene
      end

      def file_name
        File.join('scenes', "#{scene.relative_path}.adoc")
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{scene.relative_path}
        ---
        :toc:

        == #{split_slush(scene.relative_path)}

        === Diagram
        #{Diagram.new(scene).format}

        #{overridden_virtual_functions_with_title}


        === Instantiators
        #{instantiators}
        
        === Scene Tree
        #{SceneTree.new(scene).format}

        === Signal Connections
        #{signal_connections}

        #{animations_with_title}

        === Properties
        #{properties}

        #{script_with_title}

        ASCIIDOC
      end

      private

        def instantiators
          return 'CAUTION: No other scene instantiate this scene.' if scene.instantiators.none?
          scene.instantiators.map{|instantiator|
            "* link:/scenes/#{instantiator.relative_path}[#{instantiator.path}]\n"
          }.join
        end


        def signal_connections
          return 'NOTE: No signal connections.' unless scene.connections.any?

          group = scene.connections.map{|c|
              code = scene.find(c.to)&.script&.functions \
                  &.find{|f| f.name == c.method_name }&.text
              next nil unless code
              [code, c]
            }.compact.group_by{|c, _| c.object_id }

          group.map{|_, arr|
            <<~TEXT
            [.signal-connection]
            .#{arr.map{|_, c| "$#{c.from}:[#_#{c.name}_#]=>$#{c.to}" }.join(', ')}
            ```gdscript
            #{arr[0][0]}
            ```
            TEXT
          }.join
        end


        # TODO
        def properties
          scene.nodes.map{|node|
            next '' if node.section.properties.empty?
            content = node.section.properties.map{|prop|
                "|_#{node.section.name}_ |*#{prop.name}* |`#{prop.value}`"
              }.join("\n")

            title = node.root? \
              ? 'Root properties' \
              : "$#{node.path} properties"

            <<~TEXT
            .#{title}
            [cols="1,1,3" options="header"]
            |===
            |Section |Name |Value
            #{content}
            |===
            TEXT
          }.join
        end


        def script_with_title
          return '' unless scene.script
          path = Pathname(File.join('scripts', scene.script.relative_path))
          <<~ASCIIDOC
          === link:/#{path}[#{path.basename}]

          ```gdscript
          #{scene.script.raw_data}
          ```
          ASCIIDOC
        end


        def overridden_virtual_functions_with_title
          hash = scene.nodes.select(&:script).flat_map{|node|
              node.script.functions.select(&:overridden_virtual?).map{|func|
                [func.name, node.script, func.text, node]
              } }.group_by(&:first)

          return '' unless hash.any?

          txt = "=== Overridden virtual functions\n"
          hash.each do |func_name, arr|
            txt += "==== #{func_name}\n"
            arr.group_by{|a| a[1] }.each do |_, group|
              func_text = group[0][2]
              nodes = group.map(&:last)
              unless nodes[0].root?
                txt += ".#{nodes.map{|n| '$' + n.path }.join(', ')}\n"
              end
              txt += <<~ASCIIDOC
              ```gdscript
              #{func_text}
              ```
              ASCIIDOC
            end
          end
          txt
        end


        def animations_with_title
          return '' unless scene.animations.any?
          txt = "=== Animations\n"
          scene.animations.each do |animation|
            txt += "#{Animation.new(animation).format}\n"
          end
          txt
        end
    end
  end
end

