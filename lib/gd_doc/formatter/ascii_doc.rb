module GdDoc
  module Formatter
    class AsciiDoc
      attr_accessor :project, :resources, :scripts

      def initialize(composer)
        self.project = AsciiDoc::Project.new(composer.project)
      end
    end
  end
end
