module GdDoc
  module Formatter
    module Helper
      def split_slush(str)
        str.gsub('/', ' / ')
      end


      def content_link(instance)
        case instance
        when GdDoc::Scene
          Pathname(File.join('/scenes', instance.relative_path))
        when GdDoc::Script
          Pathname(File.join('/scripts', instance.relative_path))
        when GdDoc::Resource
          Pathname(File.join('/resources', instance.relative_path))
        when GdDoc::Asset::Image
          Pathname(File.join('/assets', instance.relative_path))
        else
          ''
        end
      end

      def asset_raw_link(image)
        File.join('/assets/raw', image.relative_path)
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
