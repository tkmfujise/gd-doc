module GdDoc
  module Formatter
    module Helper
      def split_slush(str)
        str.gsub('/', ' / ')
      end

      def encode_link(str)
        Addressable::URI.encode(str)
      end


      def content_link(instance)
        path = encode_link(instance.relative_path)
        case instance
        when GdDoc::Scene
          Pathname(File.join('/scenes', path))
        when GdDoc::Script
          Pathname(File.join('/scripts', path))
        when GdDoc::Resource
          Pathname(File.join('/resources', path))
        when GdDoc::Asset::Image
          Pathname(File.join('/assets', path))
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
