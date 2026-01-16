module GdDoc
  module Formatter
    class AsciiDoc::Scene::SceneTree
      include Helper
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
          suffix = node_class(node)
          txt << [
              "[.node-name.type-#{suffix}]##{node.name}#",
              (if !node.root? && node.scene
                "[.node-type.type-#{suffix}]#link:#{content_link node.scene}[#{node.scene.path}]#"
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

