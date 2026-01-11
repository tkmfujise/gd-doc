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
    end
  end
end
