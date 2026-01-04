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

        #{animations_with_title}

        === Signal Connections
        #{signal_connections}

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
          content = scene.connections.map{|c|
              "|_#{split_slush(c.from)}_ |*#{c.name}* |_#{split_slush(c.to)}_ |`#{c.method_name}`"
            }.join("\n")
          <<~TEXT
          [cols="1,1,1,2" options="header"]
          |===
          |From |Name |To |Method
          #{content}
          |===
          TEXT
        end

        # TODO
        def properties
          content = scene.sections.flat_map{|section|
              section.properties.map{|prop|
                "|_#{section.name}_ |*#{prop.name}* |`#{prop.value}`"
              }
            }.join("\n")
          <<~TEXT
          [cols="1,1,3" options="header"]
          |===
          |Section |Name |Value
          #{content}
          |===
          TEXT
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

