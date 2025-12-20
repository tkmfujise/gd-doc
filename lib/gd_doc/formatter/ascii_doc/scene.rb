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

        == #{splitted_path}

        === Diagram
        #{diagram}

        === Scene Tree
        #{scene_tree}

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
        def splitted_path
          scene.relative_path.gsub('/', ' / ')
        end

        # e.g.)
        #
        #   [.scene-tree]
        #   * [.node-name.type-2d]#Player# [.node-type.type-2d]#<CharactorBody2D>#
        #   ** [.node-name.type-2d]#CollisionShape2D# [.node-type.type-2d]#<CollisionShape2D>#
        #
        def scene_tree
          txt = "[.scene-tree]\n"
          scene.nodes.each do |node|
            txt << ('*' * node.depth.succ) + ' '
            suffix = node.type_2d? ? '2d' : (node.type_3d? ? '3d' : 'other')
            txt << [
                "[.node-name.type-#{suffix}]##{node.name}#",
                "[.node-type.type-#{suffix}]##{node.type || (node.name + '.tscn')}#",
              ].join(' ') + "\n"
          end
          txt
        end


        # TODO
        def diagram
          <<~ASCIIDOC
          [plantuml]
          ....
          class Foo
          ....
          ASCIIDOC
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

