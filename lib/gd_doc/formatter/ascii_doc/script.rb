module GdDoc
  module Formatter
    class AsciiDoc::Script < Base
      attr_accessor :script

      def initialize(script)
        self.script = script
      end

      def file_name
        File.join('scripts', "#{script.relative_path}.adoc")
      end

      def format
        <<~ASCIIDOC
        ---
        title: #{script.path}
        ---
        :toc:

        == #{split_slush(script.relative_path)}

        === Attached Scenes
        #{attached_scenes}


        === Code
        ```gdscript
        #{script.raw_data}
        ```
        ASCIIDOC
      end

      private
        def attached_scenes
          return 'NOTE: No attached scenes.' unless script.attached_scenes.any?
          content = script.attached_scenes.map{|scene|
              "* link:/scenes/#{scene.relative_path}[#{scene.path}]"
            }.join("\n")
          <<~TEXT
          #{content}
          TEXT
        end
    end
  end
end

