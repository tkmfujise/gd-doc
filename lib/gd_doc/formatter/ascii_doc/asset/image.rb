module GdDoc
  module Formatter
    class AsciiDoc::Asset::Image < Base
      attr_accessor :image

      def initialize(image)
        self.image = image
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

        === Attached Scenes
        #{attached_scenes}


        === Metadata
        [cols="1,1" options="header"]
        |===
        |Name |Value
        |Size |#{image.meta.width}×#{image.meta.height} px
        |Type |#{image.meta.type}
        |Content Length |#{image.byte_size}
        |===


        === Image
        [.asset-image]
        image::#{raw_path}[]

        ASCIIDOC
      end

      def raw_path
        asset_raw_link(image)
      end

      def store_file_paths
        { image.file => content_path_for(raw_path) }
      end


      private
        def attached_scenes
          return 'NOTE: No attached scenes.' unless image.attached_scenes.any?
          content = image.attached_scenes.map{|scene|
              "* link:/scenes/#{scene.relative_path}[#{scene.path}]\n"
            }.join
          <<~TEXT
          #{content}
          TEXT
        end
    end
  end
end


