require 'fastimage'

module GdDoc
  module Formatter
    class AsciiDoc::Asset::Image < Base
      attr_accessor :image, :meta

      def initialize(image)
        self.image = image
        self.meta  = FastImage.new(image.file)
      end

      def file_name
        File.join('assets', "#{image.relative_path}.adoc")
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{image.relative_path}
        ---
        :toc:

        == #{split_slush(image.relative_path)}


        === Metadata
        [cols="1,1" options="header"]
        |===
        |Name |Value
        |Size |#{meta.width}×#{meta.height} px
        |Type |#{meta.type}
        |Content Length |#{byte_size(meta.content_length)}
        |===


        === Image
        [.asset-image]
        image::#{raw_path}[]

        ASCIIDOC
      end

      def raw_path
        File.join('/assets/raw', image.relative_path)
      end

      def store_file_paths
        { image.file => content_path_for(raw_path) }
      end


      private
        def byte_size(bytes)
          units = %w[B KB MB GB TB]
          size  = bytes.to_f
          unit  = 0

          while size >= 1024 && unit < units.length - 1
            size /= 1024
            unit += 1
          end

          "#{size.round(2)} #{units[unit]}"
        end
    end
  end
end


