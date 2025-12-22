module GdDoc
  module Formatter
    class AsciiDoc::Scene::SceneTree
      attr_accessor :scene

      def initialize(scene)
        self.scene = scene
      end

      # e.g.)
      #
      #   [.scene-tree]
      #   * [.node-name.type-2d]#Player# [.node-type.type-2d]#<CharactorBody2D>#
      #   ** [.node-name.type-2d]#CollisionShape2D# [.node-type.type-2d]#<CollisionShape2D>#
      #
      def format
        txt = "[.scene-tree]\n"
        scene.nodes.each do |node|
          txt << ('*' * node.depth.succ) + ' '
          suffix = \
            if    node.type_2d?      then '2d'
            elsif node.type_3d?      then '3d'
            elsif node.type_control? then 'control'
            else; 'other'
            end

          txt << [
              "[.node-name.type-#{suffix}]##{node.name}#",
              (if !node.root? && node.scene
                "[.node-type.type-#{suffix}]#link:/scenes/#{node.scene.relative_path}[#{node.scene.path}]#"
              else
                "[.node-type.type-#{suffix}]##{node.type || 'Node'}#"
              end),
            ].join(' ') + "\n"
        end
        txt
      end
    end
  end
end

