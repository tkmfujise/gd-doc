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
        txt = <<~ASCIIDOC
        ---
        title: #{scene.relative_path}
        ---
        :toc:

        == #{split_slush(scene.relative_path)}

        === Diagram
        #{Diagram.new(scene).format}

        === Scene Tree
        #{SceneTree.new(scene).format}

        === Signal Connections
        #{signal_connections}

        === Properties
        #{properties}

        ASCIIDOC

        if scene.script
          path = Pathname(File.join('scripts', scene.script.relative_path))
          txt += <<~ASCIIDOC
          === link:/#{path}[#{path.basename}]

          ```gdscript
          #{scene.script.raw_data}
          ```
          ASCIIDOC
        end

        txt
      end

      private

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
    end
  end
end

