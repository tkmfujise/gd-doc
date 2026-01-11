module GdDoc
  module Formatter
    module Helper
      def split_slush(str)
        str.gsub('/', ' / ')
      end


      def node_color(node)
        if node.type_2d?
          '#87CEFA'  # lightskyblue
        elsif node.type_3d?
          '#FF69B4'  # hotpink
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


      def node_class(node)
        if    node.type_2d?      then '2d'
        elsif node.type_3d?      then '3d'
        elsif node.type_control? then 'control'
        else
          if node.type.nil? || node.type == 'Node'
            'plain'
          else
            'other'
          end
        end
      end
    end
  end
end
