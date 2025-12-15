module GdDoc
  module Formatter
    class AsciiDoc::Project < Base
      attr_accessor :project

      def initialize(project)
        self.project = project
      end

      def file_name
        'index.adoc'
      end

      def format
        <<~ASCIIDOC
        = #{project.name}

        == Properties
        ASCIIDOC
      end
    end
  end
end

