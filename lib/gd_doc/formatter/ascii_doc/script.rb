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

        == #{splitted_path}

        ```gdscript
        #{script.raw_data}
        ```
        ASCIIDOC
      end

      private
        def splitted_path
          script.relative_path.gsub('/', ' / ')
        end
    end
  end
end

