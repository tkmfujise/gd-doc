module GdDoc
  module Formatter
    class AsciiDoc::Asset::Text < Base
      attr_accessor :text

      def initialize(text)
        self.text = text
      end

      def file_name
        File.join('assets', "#{text.relative_path}.adoc")
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{text.relative_path}
        ---
        :toc:

        == #{split_slush(text.relative_path)}

        === Attached Scenes
        #{attached_scenes}


        === Code
        ```#{text.extension}
        #{text.content}
        ```

        ASCIIDOC
      end


      private
        def attached_scenes
          return 'NOTE: No attached scenes.' unless text.attached_scenes.any?
          content = text.attached_scenes.map{|scene|
              "* link:#{content_link scene}[#{scene.path}]\n"
            }.join
          <<~TEXT
          #{content}
          TEXT
        end
    end
  end
end



