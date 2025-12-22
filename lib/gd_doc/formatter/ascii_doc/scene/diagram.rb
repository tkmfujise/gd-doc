module GdDoc
  module Formatter
    class AsciiDoc::Scene::Diagram
      attr_accessor :scene

      def initialize(scene)
        self.scene = scene
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
        txt << "left to right direction\n"
        txt << "#{connection_definitions}\n"
        txt << "....\n"
        txt
      end

      # TODO
      def format2
        <<~ASCIIDOC
        [plantuml]
        ....
        class Game <<Control>> {
          ~ color_count_changed
          ~ turn_changed
          ~ all_animation_finished
          ---
          - DiskScene
          - MAX_LOCATION_NUMBER
          * current_color
          * player_color
          * animation_disks
          * cpu
          ---
          + _ready()
          + initialize()
          + place( location)
          + put( location, color )
          + clear_disks()
          + get_disks()
          + get_disk( location )
          + get_color_count(color )
          + invalid_place( location, color )
          + already_placed( location )
          + out_of_range( location )
          + reversible_count( location, color )
          + try_reverse_by( disk )
          + reversible_disks_by( disk )
          + directional_locations_from( base)
          + locations_line_from( base, dx, dy )
          + set_current_color( _color )
          + take_turn()
          + emit_signal_color_count_changed()
          + _on_board_clicked( location )
          + _on_disk_animation_finished()
          + _on_all_animation_finished()
        }
        class Board <<Polygon2D>> {
          ~ clicked
          ---
          * texture
          * repeat
          ---
          + _input( event )
          + calc_location( postion )
        }
        package "Disk" as DiskScene {
          class Disk <<AnimatedSprite2D>> {
            ~ animation_finished
            ---
            - COLOR
            * color
            * location
            ---
            + set_location( _location )
            + change_color( _color )
            + reverse()
            + _on_animation_finished()
          }
        }
        class CPU <<(C,white)>> {
          * color
          * game
          ---
          + initialize( _game )
          + perform()
          + decide_place()
          + placeable_moves()
        }
        class NormalCPU <<(C,white)>> {
          + decide_place()
        }
        class EasyCPU <<(C,white)>> {
          + decide_place()
        }
        class HardCPU <<(C,white)>> {
          + decide_place()
        }

        left to right direction

        Game --o Board
        Board --o Disk

        Game::_on_board_clicked <-[#blue,thickness=2]- Board::clicked
        Game::_on_disk_animation_finished <-[#blue,thickness=2]- Disk::animation_finished

        Game::cpu .. CPU
        CPU <|-- EasyCPU
        CPU <|-- NormalCPU
        CPU <|-- HardCPU
        ....
        ASCIIDOC
      end

      private
        def identify(node)
          identify_str node.path
        end

        def identify_str(str)
          if str == '.'
            'ROOT'
          else
            str.gsub('/', '_')
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
          if node.scene&.script
            node.scene.script.signals.each do |signal|
              txt << "  ~ #{signal.name}\n"
            end
            txt << "---\n" if node.scene.script.signals.any?
            node.scene.script.constants.each do |const|
              txt << "  - #{const.name}\n"
            end
            node.scene.script.variables.each do |var|
              txt << "  * #{var.name}\n"
            end
            txt << "---\n"
            # TODO Add arguments
            node.scene.script.functions.each do |func|
              txt << "  + #{func.name}()\n"
            end
          end
          txt += "}\n"
          txt
        end

        # <<(P,lightskyblue) Polygon2D>>
        def node_definition_subtitle(node)
          type  = node.type || 'Node'
          color = \
            if    node.type_2d?      then 'lightskyblue'
            elsif node.type_3d?      then 'hotpink'
            elsif node.type_control? then 'lightgreen'
            else; 'darkgray'
            end

          "<<(#{type[0]},#{color}) #{type}>>"
        end

        # e.g.)
        #
        #   Game::_on_board_clicked <-[#blue,thickness=2]- Board::clicked
        #
        def connection_definitions
          scene.connections.map do |c|
            "#{identify_str(c.to)}::#{c.method_name} <-[#blue,thickness=2]- #{identify_str(c.from)}::#{c.name}"
          end.join("\n")
        end 
    end
  end
end

