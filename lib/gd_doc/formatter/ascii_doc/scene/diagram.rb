module GdDoc
  module Formatter
    class AsciiDoc::Scene::Diagram
      include Helper
      attr_accessor :scene, :aliases

      def initialize(scene)
        self.scene   = scene
        self.aliases = Hash.new
      end

      def format
        txt = "[plantuml]\n....\n"
        scene.nodes.each do |node|
          txt << node_definition(node) 
        end
        scene.nodes.each do |node|
          node.children.each do |child|
            txt << "#{identify(node)} --o #{identify(child)}\n"
          end
        end

        txt << "!define _(a,b) a <-[#blue,thickness=2]- b\n"
        txt << "left to right direction\n"
        txt << "#{connection_definitions}\n"
        txt << "....\n"
        txt
      end


      private
        def identify(node)
          identify_str node.path
        end

        def identify_str(str)
          self.aliases[str] ||= begin
            if str == '.'
              'R'
            else
              "N#{aliases.count}"
            end
          end
        end
      
        # e.g.)
        #
        #   class Board <<(P,lightskyblue) Polygon2D>> {
        #     ~ clicked
        #     ---
        #     - SIZE
        #     * texture
        #     ---
        #     + _ready()
        #     + calc_location( postion )
        #   }
        #
        def node_definition(node)
          txt =  "class #{identify(node)} as \"#{node.name}\" #{node_definition_subtitle(node)} {\n"
          if node.script
            node.script.signals.each do |signal|
              txt << "  ~ #{signal.name}\n"
            end
            txt << "---\n" if node.script.signals.any?
            node.script.constants.each do |const|
              txt << "  - #{const.name}\n"
            end
            node.script.variables.each do |var|
              txt << "  * #{var.name}\n"
            end
            txt << "---\n"
            # TODO Add arguments
            node.script.functions.each do |func|
              txt << "  + #{func.name}()\n"
            end
          end
          txt += "}\n"
          txt
        end

        # <<(P,lightskyblue) Polygon2D>>
        def node_definition_subtitle(node)
          type  = node.type || 'Node'
          color = node_color(node)
          "<<(#{type[0]},#{color}) #{type}>>"
        end

        # e.g.)
        #
        #   _(Game::_on_board_clicked, Board::clicked)
        #
        # will expand by macro
        #
        #   Game::_on_board_clicked <-[#blue,thickness=2]- Board::clicked
        #
        def connection_definitions
          scene.connections.map do |c|
            "_(#{identify_str(c.to)}::#{c.method_name}, #{identify_str(c.from)}::#{c.name})"
          end.join("\n")
        end 
    end
  end
end

