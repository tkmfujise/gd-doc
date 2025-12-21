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

        ```gdscript
        #{script.raw_data}
        ```
        ASCIIDOC
      end
    end
  end
end

